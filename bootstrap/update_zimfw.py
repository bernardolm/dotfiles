#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import platform
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.run import run


def update_zimfw(dry_run: bool = False) -> None:
	if platform.system().lower() == "windows":
		return

	zimfw = Path.home() / ".zim/zimfw.zsh"
	if not zimfw.exists():
		return

	run(["zsh", "-c", f"source '{zimfw}'; zimfw install -q"], check=False, dry_run=dry_run)


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Update zimfw modules.")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	update_zimfw(dry_run=args.dry_run)
