#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path


def ensure_symlink(src: Path, dest: Path, dry_run: bool = False) -> None:
	if dry_run:
		if dest.exists() or dest.is_symlink():
			if dest.is_symlink():
				try:
					if dest.resolve() == src.resolve():
						return
				except OSError:
					pass
			backup = dest.with_suffix(dest.suffix + ".bak")
			print(f"DRY-RUN: mv {dest} {backup}")
		print(f"DRY-RUN: ln -s {src} {dest}")
		return

	dest.parent.mkdir(parents=True, exist_ok=True)
	if dest.exists() or dest.is_symlink():
		if dest.is_symlink():
			try:
				if dest.resolve() == src.resolve():
					return
			except OSError:
				pass
		backup = dest.with_suffix(dest.suffix + ".bak")
		dest.rename(backup)

	dest.symlink_to(src)


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main() -> int:
	src_value = os.environ.get("DOTFILES_SYMLINK_SRC", "").strip()
	dest_value = os.environ.get("DOTFILES_SYMLINK_DEST", "").strip()
	if not src_value or not dest_value:
		print("error: defina DOTFILES_SYMLINK_SRC e DOTFILES_SYMLINK_DEST para usar este script.")
		return 1
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	ensure_symlink(Path(src_value).expanduser(), Path(dest_value).expanduser(), dry_run=dry_run)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
