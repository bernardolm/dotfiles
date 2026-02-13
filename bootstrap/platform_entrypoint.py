#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.context import resolve_profile, select_config_path
from bootstrap.platform_bootstrap import platform_bootstrap


def run_platform_entrypoint(platform_name: str, description: str) -> int:
	parser = argparse.ArgumentParser(description=description)
	parser.add_argument("--profile", choices=["desktop", "server"], default=None)
	parser.add_argument("--host", default=None, help="Override hostname used to resolve config file.")
	parser.add_argument("--config", default=None, help="Explicit config file path.")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	try:
		profile = resolve_profile(args.profile, platform_name=platform_name)
	except ValueError as exc:
		print(str(exc))
		return 1

	config_path = (Path(args.config).expanduser()
									if args.config else select_config_path(platform_name, profile, host=args.host))

	if not config_path.exists():
		print(f"bootstrap config not found: {config_path}")
		return 1

	os.environ["DOTFILES_PROFILE"] = profile
	os.environ["DOTFILES_PLATFORM"] = platform_name

	result = platform_bootstrap(
		config_path,
		dry_run=args.dry_run,
		profile=profile,
		platform_name=platform_name,
	)
	if result == 0:
		print(
			f"Bootstrap finished (platform={platform_name}, profile={profile}, config={config_path}).")
	return result
