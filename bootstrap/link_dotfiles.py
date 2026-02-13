#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
import platform
import shutil
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.ensure_symlink import ensure_symlink
from bootstrap.repo_root import repo_root


def link_dotfiles(
	dotfiles_home: Path,
	platform_name: str | None = None,
	profile: str = "desktop",
	dry_run: bool = False,
) -> None:
	root = repo_root()
	system = (platform_name or _normalize_system(platform.system())).lower()
	profile = profile.strip().lower()

	for src, dest in _base_links(root, system=system, profile=profile):
		_ensure_link_or_copy(src, dest, dry_run=dry_run)

	if system != "windows":
		for src, dest in _unix_links(root):
			_ensure_link_or_copy(src, dest, dry_run=dry_run)

	_link_windows_terminal_and_powershell(root, system=system, dry_run=dry_run)

	if dotfiles_home != root:
		if dry_run:
			print(f"DRY-RUN: ln -s {root} {dotfiles_home}")
			return
		if not dotfiles_home.exists() and not dotfiles_home.is_symlink():
			dotfiles_home.symlink_to(root)


def _base_links(root: Path, system: str, profile: str) -> list[tuple[Path, Path]]:
	home = Path.home()
	links = [
		(root / "terminal/git/.gitconfig", home / ".gitconfig"),
		(root / "terminal/ssh/config", home / ".ssh/config"),
		(root / "terminal/starship/theme/starship.toml", home / ".config/starship.toml"),
	]

	if system != "windows" and profile != "server":
		links.append((root / "terminal/wezterm/wezterm.lua", home / ".wezterm.lua"))

	return links


def _unix_links(root: Path) -> list[tuple[Path, Path]]:
	home = Path.home()
	return [
		(root / "terminal/zsh/zdotdir/.zshenv", home / ".zshenv"),
		(root / "terminal/zsh/zdotdir/.zshrc", home / ".zshrc"),
		(root / "terminal/zsh/.zimrc", home / ".zimrc"),
		(root / "terminal/tmux/.tmux.conf", home / ".tmux.conf"),
		(root / "terminal/nano/.nanorc", home / ".nanorc"),
	]


def _link_windows_terminal_and_powershell(root: Path, system: str, dry_run: bool = False) -> None:
	if system != "windows":
		return

	home = Path.home()
	powershell_profile_src = root / "terminal/powershell/Microsoft.PowerShell_profile.ps1"
	powershell_profile_destinations = [
		home / "Documents/PowerShell/Microsoft.PowerShell_profile.ps1",
		home / "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1",
	]
	for dest in powershell_profile_destinations:
		_ensure_link_or_copy(powershell_profile_src, dest, dry_run=dry_run)

	localappdata = os.environ.get("LOCALAPPDATA", "").strip()
	if not localappdata:
		print("warning: LOCALAPPDATA not set; skipping Windows Terminal settings.")
		return

	terminal_settings_src = root / "terminal/windows-terminal/settings.json"
	terminal_settings_candidates = [
		Path(localappdata) /
		"Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json",
		Path(localappdata) /
		"Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json",
		Path(localappdata) / "Microsoft/Windows Terminal/settings.json",
	]

	existing_destinations = [item for item in terminal_settings_candidates if item.parent.exists()]
	wt_exists = shutil.which("wt") is not None or shutil.which("wt.exe") is not None
	if wt_exists and not existing_destinations:
		existing_destinations = [terminal_settings_candidates[0]]

	if not existing_destinations:
		print("warning: Windows Terminal not detected; skipping settings.json.")
		return

	for dest in existing_destinations:
		_ensure_link_or_copy(terminal_settings_src, dest, dry_run=dry_run)


def _ensure_link_or_copy(src: Path, dest: Path, dry_run: bool = False) -> None:
	if not src.exists():
		print(f"warning: source not found, skipping: {src}")
		return

	try:
		ensure_symlink(src, dest, dry_run=dry_run)
		return
	except OSError:
		pass

	if dry_run:
		print(f"DRY-RUN: cp {src} {dest}")
		return

	dest.parent.mkdir(parents=True, exist_ok=True)
	if dest.exists() or dest.is_symlink():
		if dest.is_symlink():
			try:
				if dest.resolve() == src.resolve():
					return
			except OSError:
				pass
		backup = dest.with_suffix(dest.suffix + ".bak")
		dest.rename(backup)
	shutil.copy2(src, dest)


def _normalize_system(system_name: str) -> str:
	name = system_name.lower()
	if name in {"darwin", "windows", "linux"}:
		return name
	return "linux"


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Link dotfiles into the home directory.")
	parser.add_argument("--platform", default=None)
	parser.add_argument("--profile", default=os.environ.get("DOTFILES_PROFILE", "desktop"))
	parser.add_argument("--dotfiles-home",
											default=os.environ.get("DOTFILES", str(Path.home() / "dotfiles")))
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	link_dotfiles(
		Path(args.dotfiles_home),
		platform_name=args.platform,
		profile=args.profile,
		dry_run=args.dry_run,
	)
