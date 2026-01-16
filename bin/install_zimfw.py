#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from dotfiles_tools.run import run


def install_zimfw(dry_run: bool = False) -> None:
    zim_home = Path.home() / ".zim"
    zimfw = zim_home / "zimfw.zsh"
    if zimfw.exists():
        return
    cmd = ["git", "clone", "https://github.com/zimfw/zimfw.git", str(zim_home)]
    run(cmd, check=False, dry_run=dry_run)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install zimfw if missing.")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    install_zimfw(dry_run=args.dry_run)
