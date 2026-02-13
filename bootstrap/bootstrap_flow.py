#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.context import resolve_profile, select_config_path
from bootstrap.detect_platform import detect_platform
from bootstrap.ensure_delta_config import ensure_delta_config
from bootstrap.install_zimfw import install_zimfw
from bootstrap.link_dotfiles import link_dotfiles
from bootstrap.platform_bootstrap import platform_bootstrap
from bootstrap.repo_root import repo_root
from bootstrap.update_zimfw import update_zimfw


def bootstrap_flow(install_packages: bool, link: bool, profile: str | None, dry_run: bool) -> int:
	platform_name = detect_platform()
	resolved_platform = _resolve_platform_bootstrap(platform_name)
	if not resolved_platform:
		print(f"unsupported platform for bootstrap: {platform_name}")
		return 1

	try:
		resolved_profile = resolve_profile(profile, platform_name=resolved_platform)
	except ValueError as exc:
		print(str(exc))
		return 1

	os.environ["DOTFILES_PROFILE"] = resolved_profile
	os.environ["DOTFILES_PLATFORM"] = resolved_platform

	config_path = select_config_path(resolved_platform, resolved_profile)
	if not config_path.exists():
		print(f"bootstrap config not found: {config_path}")
		return 1

	if link:
		dotfiles_home = Path.home() / "dotfiles"
		link_dotfiles(
			dotfiles_home,
			platform_name=resolved_platform,
			profile=resolved_profile,
			dry_run=dry_run,
		)
		ensure_delta_config(resolved_platform, dry_run=dry_run)
		install_zimfw(dry_run=dry_run)
		update_zimfw(dry_run=dry_run)

	if install_packages:
		result = platform_bootstrap(
			config_path,
			dry_run=dry_run,
			profile=resolved_profile,
			platform_name=resolved_platform,
		)
		if result != 0:
			return result

	print(
		"Bootstrap finished "
		f"(platform={resolved_platform}, profile={resolved_profile}, config={config_path.relative_to(repo_root())})."
	)
	return 0


def _resolve_platform_bootstrap(platform_name: str) -> str | None:
	if platform_name in {"darwin", "alpine", "ubuntu", "wsl", "windows"}:
		return platform_name
	if platform_name == "linux":
		return "ubuntu"
	return None


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def _is_falsey(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"0", "false", "no", "n", "off"}


def _resolve_action_flags() -> tuple[bool, bool]:
	all_value = os.environ.get("DOTFILES_BOOTSTRAP_ALL")
	if _is_truthy(all_value):
		return True, True

	install_value = os.environ.get("DOTFILES_BOOTSTRAP_INSTALL_PACKAGES")
	link_value = os.environ.get("DOTFILES_BOOTSTRAP_LINK")

	if install_value is None and link_value is None:
		return True, True

	install_packages = _is_truthy(install_value)
	link = _is_truthy(link_value)

	if _is_falsey(install_value) and _is_falsey(link_value):
		return False, False
	return install_packages, link


def main() -> int:
	profile = os.environ.get("DOTFILES_PROFILE") or None
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	install_packages, link = _resolve_action_flags()
	return bootstrap_flow(install_packages, link, profile, dry_run)


if __name__ == "__main__":
	raise SystemExit(main())
