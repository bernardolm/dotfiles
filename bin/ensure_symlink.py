#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path


def ensure_symlink(src: Path, dest: Path, dry_run: bool = False) -> None:
	dest.parent.mkdir(parents=True, exist_ok=True)
	if dest.exists() or dest.is_symlink():
		if dest.is_symlink() and dest.resolve() == src:
			return
		backup = dest.with_suffix(dest.suffix + ".bak")
		if dry_run:
			print(f"DRY-RUN: mv {dest} {backup}")
		else:
			dest.rename(backup)
	if dry_run:
		print(f"DRY-RUN: ln -s {src} {dest}")
	else:
		dest.symlink_to(src)


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Create a safe symlink.")
	parser.add_argument("src")
	parser.add_argument("dest")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	ensure_symlink(Path(args.src), Path(args.dest), dry_run=args.dry_run)
