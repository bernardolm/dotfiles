#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import platform
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.run import run


def install_zimfw(dry_run: bool = False) -> None:
	if platform.system().lower() == "windows":
		return

	zim_home = Path.home() / ".zim"
	zimfw = zim_home / "zimfw.zsh"
	if zimfw.exists():
		return

	run(
		["git", "clone", "https://github.com/zimfw/zimfw.git",
			str(zim_home)],
		check=False,
		dry_run=dry_run,
	)


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main() -> int:
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	install_zimfw(dry_run=dry_run)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
