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
		dotfiles_home = Path(os.environ.get("DOTFILES", str(Path.home() / "dotfiles")))
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


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Bootstrap flow runner.")
	parser.add_argument(
		"--profile",
		choices=["desktop", "server"],
		default=None,
	)
	parser.add_argument("--install-packages",
											action="store_true",
											help="Install packages for this platform")
	parser.add_argument("--link", action="store_true", help="Create symlinks to dotfiles")
	parser.add_argument("--all", action="store_true", help="Install packages and link dotfiles")
	parser.add_argument("--dry-run", action="store_true", help="Print commands without running")
	args = parser.parse_args()

	do_all = args.all or (not args.install_packages and not args.link)
	install_packages = args.install_packages or do_all
	link = args.link or do_all

	raise SystemExit(bootstrap_flow(install_packages, link, args.profile, args.dry_run))
