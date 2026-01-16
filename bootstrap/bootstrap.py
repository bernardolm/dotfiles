#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from dotfiles_tools.bootstrap_flow import bootstrap_flow  # noqa: E402


if __name__ == "__main__":
    import argparse
    import os

    parser = argparse.ArgumentParser(description="Bootstrap terminal environment.")
    parser.add_argument("--profile", choices=["desktop", "server"], default=os.environ.get("DOTFILES_PROFILE", "desktop"))
    parser.add_argument("--install-packages", action="store_true", help="Install packages for this platform")
    parser.add_argument("--link", action="store_true", help="Create symlinks to dotfiles")
    parser.add_argument("--all", action="store_true", help="Install packages and link dotfiles")
    parser.add_argument("--dry-run", action="store_true", help="Print commands without running")
    args = parser.parse_args()

    do_all = args.all or (not args.install_packages and not args.link)
    install_packages = args.install_packages or do_all
    link = args.link or do_all

    raise SystemExit(bootstrap_flow(install_packages, link, args.profile, args.dry_run))
