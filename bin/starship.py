from __future__ import annotations

from pathlib import Path

from pyfunctions.common import dotfiles_root, run


def starship_update_nerd_font(argv: list[str]) -> int:
	theme_path = dotfiles_root() / "starship" / "theme" / "starship.nerd-font-symbols.toml"
	return run(["starship", "preset", "nerd-font-symbols", "-o", str(theme_path)]).returncode


def starship_update_theme(argv: list[str]) -> int:
	root = dotfiles_root() / "starship" / "theme"
	base = root / "base_theme.toml"
	target = root / "starship.toml"
	target.write_text(base.read_text(errors="ignore"))
	with target.open("a") as handle:
	handle.write("\n\n\n\n")
	starship_update_nerd_font([])
	nerd = root / "starship.nerd-font-symbols.toml"
	with target.open("a") as handle:
	handle.write(nerd.read_text(errors="ignore"))
	return 0
