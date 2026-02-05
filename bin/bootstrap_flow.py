#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import subprocess
from pathlib import Path

from dotfiles_tools.ensure_delta_config import ensure_delta_config
from dotfiles_tools.install_zimfw import install_zimfw
from dotfiles_tools.link_dotfiles import link_dotfiles
from dotfiles_tools.repo_root import repo_root
from dotfiles_tools.update_zimfw import update_zimfw


def bootstrap_flow(install_packages: bool, link: bool, profile: str, dry_run: bool) -> int:
    platform_name = _detect_platform_cmd().strip()
    if not platform_name:
        print("platform detection failed")
        return 1

    if link:
        dotfiles_home = Path(os.environ.get("DOTFILES", str(Path.home() / "dotfiles")))
        link_dotfiles(dotfiles_home, dry_run=dry_run)
        ensure_delta_config(platform_name, dry_run=dry_run)
        install_zimfw(dry_run=dry_run)
        update_zimfw(dry_run=dry_run)

    if install_packages:
        platform_bootstrap = repo_root() / "bootstrap" / platform_name / "bootstrap.py"
        if not platform_bootstrap.exists():
            print(f"platform bootstrap not found: {platform_bootstrap}")
            return 1
        cmd = ["python3", str(platform_bootstrap)]
        if dry_run:
            cmd.append("--dry-run")
        env = os.environ.copy()
        env["DOTFILES_PROFILE"] = profile
        subprocess.run(cmd, check=False, env=env)

    print("Bootstrap finished.")
    return 0


def _detect_platform_cmd() -> str:
    env_root = Path(os.environ.get("DOTFILES", str(Path.home() / "dotfiles")))
    cmd_path = env_root / "bin/detect_platform"
    if not cmd_path.exists():
        cmd_path = repo_root() / "bin/detect_platform"
    result = subprocess.run([str(cmd_path)], check=False, capture_output=True, text=True)
    return result.stdout.strip()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Bootstrap flow runner.")
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
