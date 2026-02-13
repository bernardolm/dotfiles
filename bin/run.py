#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import subprocess


def run(cmd: list[str],
				check: bool = True,
				dry_run: bool = False,
				env: dict[str, str] | None = None) -> int:
	if dry_run:
		print("DRY-RUN:", " ".join(cmd))
		return 0
	return subprocess.run(cmd, check=check, env=env).returncode


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Run a command with optional dry-run.")
	parser.add_argument("--no-check", action="store_true", help="Do not raise on error")
	parser.add_argument("--dry-run", action="store_true", help="Print command without running")
	parser.add_argument("--env", action="append", default=[], help="Env override KEY=VALUE")
	parser.add_argument("cmd", nargs=argparse.REMAINDER)
	args = parser.parse_args()

	if not args.cmd:
		print("No command provided.")
		raise SystemExit(1)

	env = os.environ.copy()
	for item in args.env:
		if "=" in item:
			key, value = item.split("=", 1)
			env[key] = value

	raise SystemExit(run(args.cmd, check=not args.no_check, dry_run=args.dry_run, env=env))
