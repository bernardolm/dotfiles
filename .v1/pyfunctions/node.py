from __future__ import annotations

import os
from pathlib import Path

from pyfunctions.common import dotfiles_root, run


def node(argv: list[str]) -> int:
	env = os.environ.copy()
	env["COMPOSE_BAKE"] = "true"
	compose_file = dotfiles_root() / "node" / "docker-compose.yml"
	cmd = [
	"docker",
	"compose",
	"-f",
	str(compose_file),
	"run",
	"--rm",
	"--remove-orphans",
	"node",
	*argv,
	]
	return run(cmd, env=env).returncode


def tldr(argv: list[str]) -> int:
	return node(["tldr", *argv])
