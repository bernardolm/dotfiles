#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import urllib.request
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
HOME = Path.home()


def detect_os() -> str:
	prefix = os.environ.get("PREFIX", "")
	os_found = 'unknown'

	if os.environ.get("TERMUX_VERSION") or prefix.startswith("/data/data/com.termux"):
		os_found = 'termux'

	if sys.platform == 'darwin':
		os_found = 'darwin'

	if sys.platform.startswith('linux'):
		try:
			version = Path('/proc/version').read_text().lower()
		except OSError:
			version = ''

		if 'microsoft' in version or os.environ.get('WSL_DISTRO_NAME'):
			os_found = 'wsl'

		os_found = 'linux'

	return os_found


def run(cmd: list[str], apply: bool, env: dict[str, str] | None = None) -> None:
	print("+", " ".join(cmd))
	if not apply:
		return
	subprocess.run(cmd, check=True, env=env)


def ensure_symlink(src: Path, dest: Path, apply: bool) -> None:
	src = src.resolve()
	dest = dest.expanduser()

	if dest.is_symlink() and dest.resolve() == src:
		print("= link exists", dest)
		return

	if dest.exists() or dest.is_symlink():
		stamp = datetime.now().strftime("%Y%m%d%H%M%S")
		backup = dest.with_name(dest.name + ".bak-" + stamp)
		print("! backup", dest, "->", backup)
		if apply:
			dest.rename(backup)

	print("+ ln -s", src, dest)
	if apply:
		dest.parent.mkdir(parents=True, exist_ok=True)
		dest.symlink_to(src)


def brew_install(formulae: list[str], casks: list[str], apply: bool, notes: list[str]) -> None:
	brew = shutil.which("brew")
	if not brew:
		notes.append("brew not found; install Homebrew and rerun.")
		return
	if formulae:
		run([brew, "install", *formulae], apply)
	if casks:
		run([brew, "install", "--cask", *casks], apply)


def apt_install(packages: list[str], apply: bool, notes: list[str]) -> None:
	apt = shutil.which("apt-get") or shutil.which("apt")
	if not apt:
		notes.append("apt not found; install packages manually.")
		return
	sudo = []
	if hasattr(os, "geteuid") and os.geteuid() != 0 and shutil.which("sudo"):
		sudo = ["sudo"]
		run([*sudo, apt, "install", "-y", *packages], apply)


def pkg_install(packages: list[str], apply: bool, notes: list[str]) -> None:
	pkg = shutil.which("pkg") or shutil.which("apt")
	if not pkg:
		notes.append("pkg not found; install packages manually.")
		return
	run([pkg, "install", "-y", *packages], apply)


def install_starship(apply: bool, notes: list[str]) -> None:
	if shutil.which("starship"):
		print("= starship already installed")
		return
	url = "https://starship.rs/install.sh"
	print("+ download", url)
	if not apply:
		return
	script = urllib.request.urlopen(url).read().decode("utf-8")
	env = os.environ.copy()
	env["BIN_DIR"] = str(HOME / ".local/bin")
	subprocess.run(["/bin/sh"], input=script, text=True, check=True, env=env)


def install_zimfw(apply: bool, notes: list[str]) -> None:
	if not shutil.which("zsh"):
		notes.append("zsh not found; zimfw install skipped.")
		return
	zim_home = HOME / ".zim"
	if apply:
		zim_home.mkdir(parents=True, exist_ok=True)
		zimfw_path = zim_home / "zimfw.zsh"
		zimrc_path = ROOT / "zsh/zdotdir/.zimrc"
		if not zimfw_path.exists():
			url = "https://raw.githubusercontent.com/zimfw/zimfw/master/zimfw.zsh"
			print("+ download", url)
		if apply:
			content = urllib.request.urlopen(url).read()
			zimfw_path.write_bytes(content)
			env = os.environ.copy()
			env["ZIM_HOME"] = str(zim_home)
			env["ZIM_CONFIG_FILE"] = str(zimrc_path)
			run(["zsh", "-c", "source \"$ZIM_HOME/zimfw.zsh\"; zimfw install -q; zimfw init -q"], apply, env=env)


def setup_vscode_cli(os_id: str, apply: bool, notes: list[str]) -> None:
	if not shutil.which("zsh"):
		notes.append("zsh not found; vscode cli setup skipped.")
		return
	script = ROOT / "vscode/scripts/setup.sh"
	env = os.environ.copy()
	env["OS"] = os_id
	run(["zsh", str(script)], apply, env=env)


def main() -> int:
	parser = argparse.ArgumentParser(description="Bootstrap dotfiles setup.")
	parser.add_argument("--apply", action="store_true", help="Run commands.")
	parser.add_argument("--profile", choices=["desktop", "server"], default=None)
	args = parser.parse_args()

	os_id = detect_os()
	profile = args.profile or ("server" if os_id == "linux" else "desktop")
	apply = args.apply

	notes: list[str] = []
	print("os:", os_id, "profile:", profile)

	links = [
	(ROOT / "zsh/zdotdir/.zshenv", HOME / ".zshenv", True),
	(ROOT / "zsh/zdotdir/.zprofile", HOME / ".zprofile", True),
	(ROOT / "zsh/zdotdir/.zshrc", HOME / ".zshrc", True),
	(ROOT / "zsh/zdotdir/.zlogin", HOME / ".zlogin", True),
	(ROOT / "zsh/zdotdir/.zlogout", HOME / ".zlogout", True),
	(ROOT / "git/.gitconfig", HOME / ".gitconfig", True),
	(ROOT / "nano/.nanorc", HOME / ".nanorc", True),
	(ROOT / "tmux/.tmux.conf", HOME / ".tmux.conf", True),
	(ROOT / "starship/theme/catppuccin.toml", HOME / ".config/starship.toml", True),
	(ROOT / "wezterm/wezterm.lua", HOME / ".wezterm.lua", os_id in {"darwin", "wsl"}),
	]

	for src, dest, enabled in links:
		if enabled:
			ensure_symlink(src, dest, apply)

	if os_id == "darwin":
		brew_install(
			formulae=[
				"zsh",
				"tmux",
				"nano",
				"git",
				"python",
				"starship",
				"git-delta",
				"tldr",
				"go",
				"ripgrep",
				"fzf",
			],
			casks=["wezterm", "visual-studio-code", "docker"],
			apply=apply,
			notes=notes,
		)
		install_zimfw(apply, notes)
	elif os_id == "wsl":
		apt_install(
			[
				"zsh",
				"tmux",
				"nano",
				"git",
				"python3",
				"openssh-client",
				"git-delta",
				"tldr",
				"golang-go",
				"ripgrep",
				"fzf",
				"docker.io",
			],
			apply=apply,
			notes=notes,
		)
		install_starship(apply, notes)
		install_zimfw(apply, notes)
		setup_vscode_cli("wsl", apply, notes)
		notes.append("wezterm is a Windows app; install on Windows and link wezterm/wezterm.lua to %USERPROFILE%\\.wezterm.lua")
		notes.append("vscode is a Windows app; install on Windows and use WSL integration")
		notes.append("docker on WSL can use Docker Desktop; skip docker.io if preferred")
	elif os_id == "linux":
		apt_install(
			[
				"zsh",
				"tmux",
				"nano",
				"git",
				"python3",
				"openssh-client",
				"openssh-server",
				"ripgrep",
				"fzf",
				"docker.io",
			],
			apply=apply,
			notes=notes,
		)
		install_starship(apply, notes)
		install_zimfw(apply, notes)
		if profile == "server":
			setup_vscode_cli("linux", apply, notes)
			notes.append("vscode tunnel: run 'code tunnel' after setup")
	elif os_id == "termux":
		pkg_install(
			["zsh", "tmux", "nano", "git", "python", "openssh", "starship"],
			apply=apply,
			notes=notes,
		)
		install_zimfw(apply, notes)
	else:
		notes.append("unsupported OS; install tools and run links manually.")

	if notes:
		print("\nnotes:")
		for note in notes:
			print("-", note)

	if not apply:
		print("\nrun with --apply to execute.")
		return 0


if __name__ == "__main__":
	raise SystemExit(main())
