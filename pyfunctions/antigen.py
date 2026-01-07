from __future__ import annotations

import os
from pathlib import Path

from pyfunctions.common import dotfiles_root, remove_paths, run
from pyfunctions.zsh import log_debug, log_info


def antigen_start(argv: list[str]) -> int:
	log_info(["antigen_start"])
	antigen_path = os.environ.get("ANTIGEN_PATH", "")
	if not antigen_path:
	return 1
	return run(["/bin/sh", "-c", f". '{antigen_path}'"]).returncode


def _plugins_inline(path: Path) -> str:
	if not path.exists():
	return ""
	lines = [line.strip() for line in path.read_text(errors="ignore").splitlines() if line.strip() and "#" not in line]
	return " ".join(lines)


def antigen_setup(argv: list[str]) -> int:
	log_info(["setting up antigen"])
	antigen_start([])

	log_debug(["antigen use oh-my-zsh"])
	run(["antigen", "use", "oh-my-zsh"], check=False)

	plugins = _plugins_inline(dotfiles_root() / "zsh" / "plugins.txt")
	if plugins:
	log_info([f"zsh plugins: {plugins}"])
	run(["antigen", "bundle", *plugins.split()], check=False)

	plugins = _plugins_inline(dotfiles_root() / "ohmyzsh" / "plugins.txt")
	if plugins:
	log_info([f"ohmyzsh plugins: {plugins}"])
	run(["antigen", "bundle", *plugins.split()], check=False)

	log_debug(["antigen theme robbyrussell"])
	run(["antigen", "theme", "robbyrussell"], check=False)

	log_debug(["antigen apply"])
	run(["antigen", "apply"], check=False)

	log_debug(["antigen cache-gen"])
	run(["antigen", "cache-gen"], check=False)
	return 0


def antigen_purge(argv: list[str]) -> int:
	log_info(["antigen_purge"])

	for path in Path.home().glob("*.zcompdump*"):
	if path.exists():
		path.unlink()

	for path in Path.home().rglob("*.zwc"):
	if path.exists():
		path.unlink()

	antigen_path = os.environ.get("ANTIGEN_PATH")
	antigen_workdir = os.environ.get("ANTIGEN_WORKDIR")
	if antigen_path:
	remove_paths([Path(antigen_path)])
	if antigen_workdir:
	remove_paths([Path(antigen_workdir)])

	run(["zsh", "-c", "autoload -Uz compinit; compinit"], check=False)
	return 0
