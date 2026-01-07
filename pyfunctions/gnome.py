from __future__ import annotations

from pathlib import Path

from pyfunctions.common import dotfiles_root, last_backup_version, run, tmp_user_root
from pyfunctions.zsh import now_value


def gnome_conf_sanitize(argv: list[str]) -> int:
	old_gnome_config = tmp_user_root() / "old-gnome-config" / now_value()
	old_gnome_config.mkdir(parents=True, exist_ok=True)

	paths = [
	Path.home() / ".cache",
	Path.home() / ".config/dconf",
	Path.home() / ".dbus",
	Path.home() / ".dmrc",
	Path.home() / ".metacity",
	Path.home() / ".mission-control",
	Path.home() / ".thumbnails",
	]

	for item in paths:
	if item.exists():
		print(f"mv -f {item} {old_gnome_config}")
	for item in Path.home().glob(".gconf*"):
	if item.exists():
		print(f"mv -f {item} {old_gnome_config}")
	for item in Path.home().glob(".gnome*"):
	if item.exists():
		print(f"mv -f {item} {old_gnome_config}")
	return 0


def gnome_dconf_backup(argv: list[str]) -> int:
	out_file = Path.home() / "sync/linux/gnome" / f"{now_value()}.txt"
	out_file.parent.mkdir(parents=True, exist_ok=True)
	result = run(["dconf", "dump", "/"], capture=True)
	out_file.write_text(result.stdout)
	return 0


def gnome_dconf_reset(argv: list[str]) -> int:
	return run(["dconf", "reset", "-f", "/"]).returncode


def gnome_dconf_restore(argv: list[str]) -> int:
	file_path = Path(last_backup_version("gnome", "txt"))
	if not file_path.exists():
	return 1
	gnome_dconf_reset([])
	data = file_path.read_text(errors="ignore")
	return run(["dconf", "load", "/"], input_data=data).returncode


def gnome_shell_extensions_install(argv: list[str]) -> int:
	ext_file = dotfiles_root() / "gnome" / "extentions.txt"
	if not ext_file.exists():
	return 1
	extensions = [line.strip() for line in ext_file.read_text(errors="ignore").splitlines() if line.strip() and not line.strip().startswith("#")]
	if not extensions:
	return 0
	return run(["gnome-extensions-cli", "install", *extensions]).returncode


def gnome_shell_extensions_reactive(argv: list[str]) -> int:
	active = run(["gsettings", "get", "org.gnome.shell", "enabled-extensions"], capture=True).stdout.strip()
	return run(["gsettings", "set", "org.gnome.shell", "enabled-extensions", active]).returncode
