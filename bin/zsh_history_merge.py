#!/usr/bin/env python3
"""
Search for .zsh_history* files across multiple folders; merge into one file with
invalid lines removed, lines sorted ascending, and duplicates removed.
Process: transitory bucket accumulates lines until >= BUCKET_LINE_LIMIT; then
we process it (filter, sort, unique) and add to final bucket. When final bucket
reaches >= BUCKET_LINE_LIMIT we write it to partial_buckets/ and clear. Final
merge is k-way over bucket files + remaining final bucket. Work dir:
$HOME/tmp/zsh_history/{YYMMDD}/{execution_name}/.
"""

from __future__ import annotations

import argparse
from concurrent.futures import as_completed, ThreadPoolExecutor
from datetime import datetime, timezone
import gc
from heapq import merge as heapq_merge
from itertools import chain
import logging
import os
from pathlib import Path
import resource
import shutil
import signal
import sys
import threading
import time
from typing import Any, Iterator

# -----------------------------------------------------------------------------
# Config (hardcoded)
# -----------------------------------------------------------------------------
BUCKET_LINE_LIMIT = 500_000  # Spill in-memory bucket to partial_buckets/ when line count reaches this
WORK_DIR_REL = "tmp/zsh_history"  # Under $HOME; run dir is $HOME/tmp/zsh_history/{YYMMDD}/{execution_name}
TARGET_REL = "sync/.zsh_history"  # Final output: $HOME/sync/.zsh_history
PARTIAL_BUCKETS_DIR = "partial_buckets"  # Under run_dir; spilled buckets go here
GENERATED_FILE_PREFIX = ".zsh_history."  # All generated files must have this prefix
MEMORY_LIMIT_GB = 20  # Max process memory (set via resource limit on Unix); no-op on Windows
# -----------------------------------------------------------------------------


def _set_memory_limit_gb(limit_gb: int) -> None:
	"""Set process virtual memory limit to limit_gb (Unix only). Helps cap total memory use."""
	if limit_gb <= 0:
		return
	try:
		limit_bytes = limit_gb * (1024**3)
		resource.setrlimit(resource.RLIMIT_AS, (limit_bytes, limit_bytes))
		LOG.debug("Memory limit set to %d GiB", limit_gb)
	except (ValueError, OSError, AttributeError):
		pass  # Windows has no resource.RLIMIT_AS; or permission denied


LOG = logging.getLogger("zsh_history_merge")

HISTORY_FILE_PREFIX = ".zsh_history"
EXCLUDE_NAME = ".zsh_history_new"
VALID_LINE_PREFIX = ":"

_LOG_INTERVAL = 1.0
_last_progress_log = 0.0
_progress_lock = threading.Lock()

# Set by main() during the parallel phase so forced-exit handler can save partial state.
_partial_ctx: dict[str, Any] | None = None


def _save_partial_and_exit(signum: int, _frame: Any = None) -> None:
	"""On SIGINT/SIGTERM, merge to run_dir/merged, copy to target, exit."""
	global _partial_ctx
	if _partial_ctx is None:
		sys.exit(130 if signum == signal.SIGINT else 143)
	target = _partial_ctx["final_output"]
	dry_run = _partial_ctx["dry_run"]
	run_dir = _partial_ctx.get("run_dir")
	work_merged = run_dir / (GENERATED_FILE_PREFIX + "merged") if run_dir else None
	if not dry_run and run_dir is not None:
		run_dir.mkdir(parents=True, exist_ok=True)
	bucket_paths = _partial_ctx["bucket_paths"]
	all_chunks = _partial_ctx["all_chunks"]
	final_bucket = _partial_ctx.get("final_bucket") or []
	partial_buckets_dir = run_dir / PARTIAL_BUCKETS_DIR if run_dir else None
	if all_chunks and final_bucket is not None and partial_buckets_dir is not None:
		_process_transitory_into_final(all_chunks, final_bucket, partial_buckets_dir, bucket_paths,
																		dry_run)
	if (bucket_paths or final_bucket) and work_merged is not None:
		_merge_to_output(bucket_paths, [final_bucket] if final_bucket else [], work_merged, dry_run)
		if not dry_run and work_merged.exists():
			try:
				shutil.copy2(work_merged, target)
				LOG.info("Forced exit: copied partial state to %s", target)
			except OSError as e:
				LOG.warning("Could not copy to target: %s", e)
	sys.exit(130 if signum == signal.SIGINT else 143)


def _dt() -> datetime:
	return datetime.now(timezone.utc)


def _normalize(lines: list[str]) -> list[str]:
	"""Keep valid lines, sort ascending, dedup via set (faster than dict.fromkeys when many dupes)."""
	valid = (ln for ln in lines if ln.startswith(VALID_LINE_PREFIX))
	return sorted(set(valid))


def _merge_to_output(
	bucket_paths: list[Path],
	all_chunks: list[list[str]],
	final_output: Path,
	dry_run: bool,
) -> None:
	"""K-way merge partial bucket files + in-memory chunks (sorted, deduped) into final_output."""
	if dry_run:
		LOG.info("Dry run: would write final merge to %s", final_output.resolve())
		return
	iters: list[Iterator[str]] = []
	open_files: list[Any] = []
	try:
		for p in bucket_paths:
			if p.is_file():
				fp = p.open(encoding="utf-8", errors="replace")
				open_files.append(fp)
				iters.append(iter(fp))
		flat = list(chain.from_iterable(all_chunks))
		if flat:
			iters.append(iter(_normalize(flat)))
		if not iters:
			LOG.warning("No data to merge; final file not written (path would be %s)",
									final_output.resolve())
			return
		final_output = final_output.resolve()
		final_output.parent.mkdir(parents=True, exist_ok=True)
		merged = heapq_merge(*iters)
		last: str | None = None
		with final_output.open("w", encoding="utf-8") as out:
			for line in merged:
				if line != last:
					out.write(line)
					last = line
		LOG.debug("Merged result written to %s", final_output)
	finally:
		for fp in open_files:
			fp.close()


def _process_transitory_into_final(
	all_chunks: list[list[str]],
	final_bucket: list[str],
	partial_buckets_dir: Path,
	bucket_paths: list[Path],
	dry_run: bool,
) -> None:
	"""Process transitory bucket (filter, sort, unique); add to final_bucket. If final_bucket >= BUCKET_LINE_LIMIT, write file(s) and clear."""
	flat = list(chain.from_iterable(all_chunks))
	all_chunks.clear()
	processed = _normalize(flat)
	final_bucket.extend(processed)
	del flat
	del processed
	gc.collect()
	if dry_run:
		return
	partial_buckets_dir.mkdir(parents=True, exist_ok=True)
	while len(final_bucket) >= BUCKET_LINE_LIMIT:
		to_write = final_bucket[:BUCKET_LINE_LIMIT]
		del final_bucket[:BUCKET_LINE_LIMIT]
		path = partial_buckets_dir / f"{GENERATED_FILE_PREFIX}bucket_{len(bucket_paths):06d}.txt"
		path.write_text("".join(to_write), encoding="utf-8")
		bucket_paths.append(path)
		LOG.debug("Wrote bucket to %s (%d lines)", path, len(to_write))
		del to_write
		gc.collect()


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
	*,
	current: int = 0,
	total: int = 0,
	dry_run: bool = False,
) -> list[str] | None:
	"""Read file, normalize (filter/sort/dedup), delete source file; return lines."""
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
	if not dry_run:
		try:
			source_path.unlink()
		except OSError as e:
			LOG.warning("Could not delete %s: %s", source_path, e)
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

	_set_memory_limit_gb(MEMORY_LIMIT_GB)

	dry_run = args.dry_run
	home = Path.home()
	now = _dt()
	date_now = now.strftime("%y%m%d")

	target_path = home / TARGET_REL
	work_path = home / WORK_DIR_REL

	LOG.info("Starting (dry_run=%s)", dry_run)
	LOG.info("Target path: %s", target_path.resolve())

	zdotdir = Path(os.environ.get("ZDOTDIR", str(home)))
	sources = [(home / "tmp/workspace", None), (zdotdir, None),
							(home / "Library/CloudStorage/Dropbox", None)]
	found = list(find_files(sources))
	if target_path.exists() and target_path not in found:
		found.append(target_path)
	LOG.info("Discovery: %d file(s) in %d path(s)", len(found), len(sources))

	total_files = len(found)
	cpu_count = os.cpu_count() or 1
	workers = max(1, min(total_files, int(cpu_count * 0.8)))
	execution_name = now.strftime("%H%M%S")
	run_dir = work_path / date_now / execution_name
	partial_buckets_dir = run_dir / PARTIAL_BUCKETS_DIR

	all_chunks: list[list[str]] = []  # transitory bucket
	final_bucket: list[str] = []
	bucket_paths: list[Path] = []
	bucket_line_count = 0
	last_completed_log = 0.0
	completed = 0

	global _partial_ctx
	_partial_ctx = {
		"final_output": target_path,
		"dry_run": dry_run,
		"run_dir": run_dir,
		"all_chunks": all_chunks,
		"final_bucket": final_bucket,
		"bucket_paths": bucket_paths,
	}
	signal.signal(signal.SIGINT, _save_partial_and_exit)
	signal.signal(signal.SIGTERM, _save_partial_and_exit)
	try:
		with ThreadPoolExecutor(max_workers=workers) as executor:
			futures = [
				executor.submit(process_one, p, current=j + 1, total=total_files, dry_run=dry_run)
				for j, p in enumerate(found)
			]
			for fut in as_completed(futures):
				if (chunk := fut.result()) is not None:
					all_chunks.append(chunk)
					bucket_line_count += len(chunk)
					if not dry_run and bucket_line_count >= BUCKET_LINE_LIMIT and all_chunks:
						_process_transitory_into_final(all_chunks, final_bucket, partial_buckets_dir,
																						bucket_paths, dry_run)
						bucket_line_count = 0
				completed += 1
				now = time.monotonic()
				if now - last_completed_log >= _LOG_INTERVAL or completed == total_files:
					LOG.info("Completed (%d/%d)", completed, total_files)
					last_completed_log = now
	finally:
		_partial_ctx = None
		signal.signal(signal.SIGINT, signal.SIG_DFL)
		signal.signal(signal.SIGTERM, signal.SIG_DFL)

	# All work (partial buckets, merged result) lives under run_dir only.
	run_dir.mkdir(parents=True, exist_ok=True)
	work_merged = run_dir / (GENERATED_FILE_PREFIX + "merged")
	# Process any remaining transitory into final bucket.
	if all_chunks:
		_process_transitory_into_final(all_chunks, final_bucket, partial_buckets_dir, bucket_paths,
																		dry_run)
	# Merge partial bucket files + in-memory final_bucket to work dir, then copy to target.
	_merge_to_output(bucket_paths, [final_bucket] if final_bucket else [], work_merged, dry_run)
	if not dry_run and work_merged.exists():
		target_path.parent.mkdir(parents=True, exist_ok=True)
		try:
			shutil.copy2(work_merged, target_path)
			LOG.info("Final file written to %s", target_path.resolve())
		except OSError as e:
			LOG.warning("Could not copy to target: %s", e)
	LOG.info("Done. %d file(s) processed, %d bucket(s)", total_files, len(bucket_paths))
	return 0


if __name__ == "__main__":
	sys.exit(main())
