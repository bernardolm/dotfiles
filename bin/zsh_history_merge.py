#!/usr/bin/env python3
from __future__ import annotations

import fnmatch
import os
from pathlib import Path


def _same_file(path_a: Path, path_b: Path) -> bool:
	try:
		return path_a.samefile(path_b)
	except OSError:
		return path_a.resolve() == path_b.resolve()


def _append_and_delete(source_file: Path, official_file: Path) -> None:
	if not source_file.exists() or not source_file.is_file():
		return
	if _same_file(source_file, official_file):
		return

	try:
		with source_file.open("rb") as source_handle, official_file.open("ab") as target_handle:
			target_handle.write(source_handle.read())
	except OSError:
		return

	try:
		source_file.unlink()
	except OSError:
		return


def _scan_history_files(home_dir: Path, official_file: Path, pattern: str) -> list[Path]:
	found: list[Path] = []
	for root, _, files in os.walk(home_dir, followlinks=False):
		root_path = Path(root)
		for name in files:
			if not fnmatch.fnmatch(name, pattern):
				continue
			file_path = root_path / name
			if _same_file(file_path, official_file):
				continue
			found.append(file_path)
	return found


def _acquire_lock(lock_dir: Path) -> bool:
	try:
		lock_dir.mkdir(parents=True, exist_ok=False)
		return True
	except FileExistsError:
		return False
	except OSError:
		return False


def merge_history(
	official_file: Path,
	home_dir: Path,
	previous_files: list[Path] | None = None,
	legacy_files: list[Path] | None = None,
	scan_pattern: str = "*zsh_history*",
	lock_dir: Path | None = None,
) -> int:
	resolved_lock_dir = lock_dir or (
		Path(os.environ.get("XDG_CACHE_HOME", str(Path.home() / ".cache"))) /
		"dotfiles-zsh-history-merge.lock")
	if not _acquire_lock(resolved_lock_dir):
		return 0

	try:
		official_file.parent.mkdir(parents=True, exist_ok=True)
		official_file.touch(exist_ok=True)

		for path in previous_files or []:
			_append_and_delete(path.expanduser(), official_file)
		for path in legacy_files or []:
			_append_and_delete(path.expanduser(), official_file)

		for source_file in _scan_history_files(home_dir, official_file, scan_pattern):
			_append_and_delete(source_file, official_file)
	finally:
		try:
			resolved_lock_dir.rmdir()
		except OSError:
			pass

	return 0


def _split_paths(value: str) -> list[Path]:
	items: list[Path] = []
	for raw in value.split(os.pathsep):
		entry = raw.strip()
		if entry:
			items.append(Path(entry).expanduser())
	return items


def _default_legacy_files() -> list[Path]:
	home_dir = Path.home()
	zdotdir = Path(os.environ.get("ZDOTDIR", str(home_dir))).expanduser()
	xdg_state_home = Path(os.environ.get("XDG_STATE_HOME",
																				str(home_dir / ".local/state"))).expanduser()
	return [
		home_dir / ".zsh_history",
		zdotdir / ".zsh_history",
		xdg_state_home / "zsh/history",
	]


def main() -> int:
	home_dir = Path(os.environ.get("DOTFILES_ZSH_HISTORY_HOME_DIR", str(Path.home()))).expanduser()
	official_file = Path(
		os.environ.get("DOTFILES_ZSH_HISTORY_OFFICIAL_FILE",
										str(Path.home() / "sync/.zsh_history"))).expanduser()
	lock_dir = Path(
		os.environ.get(
			"DOTFILES_ZSH_HISTORY_LOCK_DIR",
			str(
				Path(os.environ.get("XDG_CACHE_HOME", str(Path.home() / ".cache"))) /
				"dotfiles-zsh-history-merge.lock"),
		)).expanduser()
	scan_pattern = os.environ.get("DOTFILES_ZSH_HISTORY_SCAN_PATTERN", "*zsh_history*")

	previous_files = _split_paths(os.environ.get("DOTFILES_ZSH_HISTORY_PREVIOUS_FILES", ""))
	legacy_raw = os.environ.get("DOTFILES_ZSH_HISTORY_LEGACY_FILES", "")
	legacy_files = _split_paths(legacy_raw) if legacy_raw else _default_legacy_files()

	return merge_history(
		official_file=official_file,
		home_dir=home_dir,
		previous_files=previous_files,
		legacy_files=legacy_files,
		scan_pattern=scan_pattern,
		lock_dir=lock_dir,
	)


if __name__ == "__main__":
	raise SystemExit(main())
