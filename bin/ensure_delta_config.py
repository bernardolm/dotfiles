#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from dotfiles_tools.ensure_symlink import ensure_symlink
from dotfiles_tools.repo_root import repo_root


def ensure_delta_config(platform_name: str, dry_run: bool = False) -> None:
	root = repo_root()
	delta_src = root / "terminal/git/gitconfig.delta"
	delta_dest = Path.home() / ".config/git/delta.conf"
	if platform_name in {"darwin", "wsl"}:
		ensure_symlink(delta_src, delta_dest, dry_run=dry_run)
	else:
		if delta_dest.exists() and not dry_run:
			delta_dest.unlink()


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Link delta config on supported platforms.")
	parser.add_argument("platform")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	ensure_delta_config(args.platform, dry_run=args.dry_run)
