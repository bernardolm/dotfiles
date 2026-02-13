#!/usr/bin/env python3
from __future__ import annotations

import argparse
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


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Create a safe symlink.")
	parser.add_argument("src")
	parser.add_argument("dest")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	ensure_symlink(Path(args.src), Path(args.dest), dry_run=args.dry_run)
