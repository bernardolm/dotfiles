#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import shlex
from typing import Any

from dotfiles_tools.load_config import load_config
from dotfiles_tools.run import run


def platform_bootstrap(config_path: Path, dry_run: bool = False) -> int:
	if not config_path.exists():
		print(f"config not found: {config_path}")
		return 1

	config = load_config(config_path)
	envs = config.get("envs", {}) if isinstance(config, dict) else {}
	if isinstance(envs, dict):
		for key, value in envs.items():
			os.environ[str(key)] = str(value)

	default_manager = str(config.get("package-manager", "")).strip() if isinstance(config,
																																									dict) else ""
	packages = config.get("packages", []) if isinstance(config, dict) else []

	for item in packages:
		pkg = _normalize_package(item)
		if not pkg:
			continue
		_apply_package(pkg, default_manager, dry_run=dry_run)

	return 0


def _normalize_package(item: Any) -> dict[str, Any] | None:
	if isinstance(item, str):
		return {
			"name": item
		}
	if isinstance(item, dict):
		if "name" in item:
			return dict(item)
		if len(item) == 1:
			key = next(iter(item))
			value = item[key]
			if isinstance(value, dict):
				pkg = dict(value)
			else:
				pkg = {}
			pkg["name"] = key
			return pkg
		return dict(item)
	return None


def _apply_package(pkg: dict[str, Any], default_manager: str, dry_run: bool = False) -> None:
	name = str(pkg.get("name", "")).strip()
	if not name:
		return

	manager = str(pkg.get("manager", default_manager)).strip()
	action = str(pkg.get("action", "install")).strip()
	command = pkg.get("command")

	if command:
		cmd = ["/bin/sh", "-c", str(command)]
		run(cmd, check=False, dry_run=dry_run)
		return

	if manager == "curl":
		url = str(pkg.get("curl_url") or pkg.get("url") or "").strip()
		if not url:
			return
		if action != "install":
			return
		cmd = ["/bin/sh", "-c", f"curl -fsSL {shlex.quote(url)} | sh"]
		run(cmd, check=False, dry_run=dry_run)
		return

	cmd = _build_manager_cmd(manager, action, name, pkg)
	if cmd:
		run(cmd, check=False, dry_run=dry_run)


def _build_manager_cmd(manager: str, action: str, name: str, pkg: dict[str, Any]) -> list[str]:
	if manager == "brew":
		if action == "install":
			return ["brew", "install", name]
		return ["brew", "uninstall", name]

	if manager == "apt":
		sudo = [] if os.geteuid() == 0 else ["sudo"]
		if action == "install":
			return [*sudo, "apt-get", "install", "-y", name]
		if action == "purge":
			return [*sudo, "apt-get", "purge", "-y", name]
		return [*sudo, "apt-get", "remove", "-y", name]

	if manager == "pkg":
		if action == "install":
			return ["pkg", "install", "-y", name]
		return ["pkg", "uninstall", "-y", name]

	if manager == "pip":
		if action == "install":
			return ["python3", "-m", "pip", "install", name]
		return ["python3", "-m", "pip", "uninstall", "-y", name]

	if manager == "go":
		version = str(pkg.get("version", "latest")).strip()
		suffix = f"@{version}" if "@" not in name else ""
		if action == "install":
			return ["go", "install", f"{name}{suffix}"]
		return []

	if manager == "npm":
		if action == "install":
			return ["npm", "install", "-g", name]
		return ["npm", "uninstall", "-g", name]

	if manager == "winget":
		if action == "install":
			return ["winget", "install", "--id", name]
		return ["winget", "uninstall", "--id", name]

	return []


if __name__ == "__main__":
	import argparse

	parser = argparse.ArgumentParser(description="Run platform-specific bootstrap using config.yml.")
	parser.add_argument("config")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	raise SystemExit(platform_bootstrap(Path(args.config), dry_run=args.dry_run))
