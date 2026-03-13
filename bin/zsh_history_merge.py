#!/usr/bin/env python3
"""
Search for .zsh_history* files across multiple folders; merge into one file with
invalid lines removed, lines sorted ascending, and duplicates removed.
Uses in-memory merge (no temp files), parallel I/O, and set-based dedup for speed.
"""

from __future__ import annotations

import argparse
from concurrent.futures import as_completed, ThreadPoolExecutor
from datetime import datetime, timezone
from itertools import chain
import logging
import os
from pathlib import Path
import sys
import threading
import time
from typing import Iterator


LOG = logging.getLogger("zsh_history_merge")

HISTORY_FILE_PREFIX = ".zsh_history"
FILE_PREFIX = ".zsh_history."
EXCLUDE_NAME = ".zsh_history_new"
VALID_LINE_PREFIX = ":"
BACKUP_EXT = ".old"

_LOG_INTERVAL = 1.0
_last_progress_log = 0.0
_progress_lock = threading.Lock()


def _dt() -> datetime:
	return datetime.now(timezone.utc)


def _backup_basename(seq: int) -> str:
	d = _dt()
	return f"{FILE_PREFIX}{d:%y%m%d}{d:%H%M%S}.{seq:06d}{BACKUP_EXT}"


def _normalize(lines: list[str]) -> list[str]:
	"""Keep valid lines, sort ascending, dedup via set (faster than dict.fromkeys when many dupes)."""
	valid = (ln for ln in lines if ln.startswith(VALID_LINE_PREFIX))
	return sorted(set(valid))


def find_files(
	sources: list[tuple[Path, int | None]],
	exclude: str = EXCLUDE_NAME,
) -> Iterator[Path]:
	pattern = HISTORY_FILE_PREFIX + "*"
	for root, max_depth in sources:
		if not root.exists():
			continue
		depth_ok = (lambda p, r=root, m=max_depth: len(p.relative_to(r).parts) <= m
								) if max_depth is not None else (lambda p: True)
		files = [p for p in root.rglob(pattern) if p.is_file() and p.name != exclude and depth_ok(p)]
		yield from files
		if files:
			LOG.info("  Found %d file(s)", len(files))


def process_one(
	source_path: Path,
	backup_dir: Path,
	backup_basename: str,
	*,
	current: int = 0,
	total: int = 0,
	dry_run: bool = False,
) -> list[str] | None:
	"""Read file, normalize (filter/sort/dedup), move original to backup; return lines or None."""
	if not source_path.is_file():
		LOG.warning("Skipping (not a file)")
		return None
	if total:
		global _last_progress_log
		now = time.monotonic()
		with _progress_lock:
			if now - _last_progress_log >= _LOG_INTERVAL or current == 1 or current == total:
				LOG.info("Processing (%d/%d)", current, total)
				_last_progress_log = now

	raw = source_path.read_text(encoding="utf-8", errors="replace")
	lines = _normalize(raw.splitlines(keepends=True))

	if dry_run:
		return lines
	backup_path = backup_dir / backup_basename
	backup_path.parent.mkdir(parents=True, exist_ok=True)
	source_path.rename(backup_path)
	return lines


def _parse_args() -> argparse.Namespace:
	p = argparse.ArgumentParser(
		description="Merge .zsh_history files (filter, sort ascending, unique).")
	p.add_argument("--dry-run", action="store_true", help="No writes or moves.")
	p.add_argument("-q", "--quiet", action="store_true", help="Warnings and errors only.")
	p.add_argument("-v", "--verbose", action="store_true", help="Debug logging.")
	p.add_argument("-l",
									"--log-level",
									choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
									metavar="LEVEL",
									help="Override -q/-v.")
	return p.parse_args()


def main() -> int:
	args = _parse_args()
	level = getattr(logging, args.log_level) if args.log_level else (
		logging.DEBUG if args.verbose else (logging.WARNING if args.quiet else logging.INFO))
	logging.basicConfig(level=level, format="%(levelname)s: %(message)s")
	LOG.setLevel(level)

	dry_run = args.dry_run
	home = Path.home()
	now = _dt()
	date_now = now.strftime("%y%m%d")

	final_output = home / "sync/.zsh_history"
	work_path = home / "tmp/zsh_history"
	backup_dir = work_path / date_now

	LOG.info("Starting (dry_run=%s)", dry_run)
	if not dry_run:
		backup_dir.mkdir(parents=True, exist_ok=True)

	zdotdir = Path(os.environ.get("ZDOTDIR", str(home)))
	sources = [(home / "tmp/workspace", None), (zdotdir, None),
							(home / "Library/CloudStorage/Dropbox", None)]
	found = list(find_files(sources))
	if final_output.exists() and final_output not in found:
		found.append(final_output)
	LOG.info("Discovery: %d file(s) in %d path(s)", len(found), len(sources))

	total_files = len(found)
	workers = max(1, min(total_files, (os.cpu_count() * 2) or 1))
	backup_names = [_backup_basename(i) for i in range(1, total_files + 1)]

	all_chunks: list[list[str]] = []
	last_completed_log = 0.0
	completed = 0
	with ThreadPoolExecutor(max_workers=workers) as executor:
		futures = [
			executor.submit(process_one,
											p,
											backup_dir,
											backup_names[j],
											current=j + 1,
											total=total_files,
											dry_run=dry_run) for j, p in enumerate(found)
		]
		for fut in as_completed(futures):
			if (chunk := fut.result()) is not None:
				all_chunks.append(chunk)
			completed += 1
			now = time.monotonic()
			if now - last_completed_log >= _LOG_INTERVAL or completed == total_files:
				LOG.info("Completed (%d/%d)", completed, total_files)
				last_completed_log = now

	# Single merge: flatten, filter, sort ascending, dedup
	all_lines = chain.from_iterable(all_chunks)
	merged = _normalize(list(all_lines))
	LOG.info("Merge: %d lines", len(merged))

	if not dry_run:
		final_output.parent.mkdir(parents=True, exist_ok=True)
		final_output.write_text("".join(merged), encoding="utf-8")
	LOG.info("Done. %d file(s) processed", total_files)
	return 0


if __name__ == "__main__":
	sys.exit(main())
