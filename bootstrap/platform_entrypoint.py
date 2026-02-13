#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.context import resolve_profile, select_config_path
from bootstrap.platform_bootstrap import platform_bootstrap


def run_platform_entrypoint(
	platform_name: str,
	description: str,
	profile: str | None = None,
	host: str | None = None,
	config: str | Path | None = None,
	dry_run: bool = False,
) -> int:
	_ = description
	try:
		resolved_profile = resolve_profile(profile, platform_name=platform_name)
	except ValueError as exc:
		print(str(exc))
		return 1

	if config is None:
		config_path = select_config_path(platform_name, resolved_profile, host=host)
	else:
		config_path = Path(config).expanduser()

	if not config_path.exists():
		print(f"bootstrap config not found: {config_path}")
		return 1

	os.environ["DOTFILES_PROFILE"] = resolved_profile
	os.environ["DOTFILES_PLATFORM"] = platform_name

	result = platform_bootstrap(
		config_path,
		dry_run=dry_run,
		profile=resolved_profile,
		platform_name=platform_name,
	)
	if result == 0:
		print(
			f"Bootstrap finished (platform={platform_name}, profile={resolved_profile}, config={config_path})."
		)
	return result


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main(platform_name: str, description: str) -> int:
	profile = os.environ.get("DOTFILES_PROFILE") or None
	host = os.environ.get("DOTFILES_BOOTSTRAP_HOST") or None
	config = os.environ.get("DOTFILES_BOOTSTRAP_CONFIG") or None
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	return run_platform_entrypoint(
		platform_name,
		description,
		profile=profile,
		host=host,
		config=config,
		dry_run=dry_run,
	)
