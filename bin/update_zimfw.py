#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from dotfiles_tools.run import run


def update_zimfw(dry_run: bool = False) -> None:
	zimfw = Path.home() / ".zim/zimfw.zsh"
	if not zimfw.exists():
		return
	cmd = ["zsh", "-c", f"source '{zimfw}'; zimfw install -q"]
	run(cmd, check=False, dry_run=dry_run)


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Update zimfw modules.")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	update_zimfw(dry_run=args.dry_run)
