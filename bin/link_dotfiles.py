#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path

from dotfiles_tools.ensure_symlink import ensure_symlink
from dotfiles_tools.repo_root import repo_root


def link_dotfiles(dotfiles_home: Path, dry_run: bool = False) -> None:
	root = repo_root()
	links = [
		(root / "terminal/zsh/.zshenv", Path.home() / ".zshenv"),
		(root / "terminal/zsh/.zshrc", Path.home() / ".zshrc"),
		(root / "terminal/zsh/.zimrc", Path.home() / ".zimrc"),
		(root / "terminal/starship/starship.toml", Path.home() / ".config/starship.toml"),
		(root / "terminal/tmux/.tmux.conf", Path.home() / ".tmux.conf"),
		(root / "terminal/git/gitconfig", Path.home() / ".gitconfig"),
		(root / "terminal/nano/.nanorc", Path.home() / ".nanorc"),
		(root / "terminal/ssh/config", Path.home() / ".ssh/config"),
		(root / "terminal/wezterm/wezterm.lua", Path.home() / ".wezterm.lua"),
	]

	for src, dest in links:
		ensure_symlink(src, dest, dry_run=dry_run)

	if dotfiles_home != root:
		if dry_run:
			print(f"DRY-RUN: ln -s {root} {dotfiles_home}")
		else:
			if dotfiles_home.exists() or dotfiles_home.is_symlink():
				return
			dotfiles_home.symlink_to(root)


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Link dotfiles into the home directory.")
	parser.add_argument("--dotfiles-home",
											default=os.environ.get("DOTFILES", str(Path.home() / "dotfiles")))
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	link_dotfiles(Path(args.dotfiles_home), dry_run=args.dry_run)
