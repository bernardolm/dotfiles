#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import shutil

from dotfiles_tools.run import run


def install_packages(platform_name: str, profile: str, dry_run: bool = False) -> None:
    base = ["zsh", "starship", "tmux", "nano", "git", "python3", "openssh-client"]
    if profile == "server":
        base.append("openssh-server")

    extras = []
    if platform_name in {"darwin", "wsl"}:
        extras += ["wezterm", "git-delta", "tldr", "go", "vscode"]
    if platform_name in {"darwin", "wsl", "linux"}:
        extras += ["ripgrep", "fzf", "docker"]

    if platform_name == "darwin":
        if not shutil.which("brew"):
            print("brew not found. Install Homebrew and rerun.")
            return
        run(["brew", "update"], check=False, dry_run=dry_run)
        for pkg in base:
            run(["brew", "install", pkg], check=False, dry_run=dry_run)
        for pkg in extras:
            if pkg in {"wezterm", "vscode", "docker"}:
                run(["brew", "install", "--cask", pkg], check=False, dry_run=dry_run)
            else:
                run(["brew", "install", pkg], check=False, dry_run=dry_run)
        return

    if platform_name in {"linux", "wsl"}:
        sudo = [] if os.geteuid() == 0 else ["sudo"]
        run([*sudo, "apt-get", "update"], check=False, dry_run=dry_run)
        for pkg in base:
            run([*sudo, "apt-get", "install", "-y", pkg], check=False, dry_run=dry_run)
        for pkg in extras:
            run([*sudo, "apt-get", "install", "-y", pkg], check=False, dry_run=dry_run)
        if platform_name == "wsl":
            print("wezterm/vscode are expected on Windows host. Configure with wezterm.lua as needed.")
        return

    if platform_name == "termux":
        run(["pkg", "update"], check=False, dry_run=dry_run)
        for pkg in base:
            run(["pkg", "install", "-y", pkg], check=False, dry_run=dry_run)
        return

    print(f"Unsupported platform: {platform_name}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install platform packages.")
    parser.add_argument("platform")
    parser.add_argument("--profile", choices=["desktop", "server"], default="desktop")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    install_packages(args.platform, args.profile, dry_run=args.dry_run)
