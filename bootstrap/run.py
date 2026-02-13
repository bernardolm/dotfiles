#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import shlex
import subprocess


def run(
	cmd: list[str],
	check: bool = True,
	dry_run: bool = False,
	env: dict[str, str] | None = None,
	cwd: Path | None = None,
) -> int:
	if dry_run:
		print("DRY-RUN:", " ".join(shlex.quote(part) for part in cmd))
		return 0

	completed = subprocess.run(cmd, check=False, env=env, cwd=str(cwd) if cwd else None)
	if check and completed.returncode != 0:
		raise subprocess.CalledProcessError(completed.returncode, cmd)
	return completed.returncode


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main() -> int:
	cmd_value = os.environ.get("DOTFILES_RUN_CMD", "").strip()
	if not cmd_value:
		print("No command provided. Set DOTFILES_RUN_CMD.")
		return 1

	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	check = not _is_truthy(os.environ.get("DOTFILES_RUN_NO_CHECK", "0"))
	cwd_value = os.environ.get("DOTFILES_RUN_CWD", "").strip()
	cwd = Path(cwd_value).expanduser() if cwd_value else None
	env = os.environ.copy()

	raw_env = os.environ.get("DOTFILES_RUN_ENV", "").strip()
	if raw_env:
		for item in raw_env.split(";;"):
			if "=" not in item:
				continue
			key, value = item.split("=", 1)
			env[key] = value

	cmd = shlex.split(cmd_value)
	return run(cmd, check=check, dry_run=dry_run, env=env, cwd=cwd)


if __name__ == "__main__":
	raise SystemExit(main())
