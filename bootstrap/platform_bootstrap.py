#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
import shlex
import shutil
import sys
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.load_config import load_config
from bootstrap.run import run


def platform_bootstrap(config_path: Path, dry_run: bool = False) -> int:
	if not config_path.exists():
		print(f"config not found: {config_path}")
		return 1

	config = load_config(config_path)
	if not isinstance(config, dict):
		print(f"invalid config format: {config_path}")
		return 1

	_apply_envs(config.get("envs", {}))

	default_manager = str(config.get("package-manager", "")).strip()
	packages = config.get("packages", [])
	if not isinstance(packages, list):
		print("invalid 'packages' section: expected list")
		return 1

	failures = 0
	for item in packages:
		pkg = _normalize_package(item)
		if not pkg:
			continue
		ok = _apply_package(pkg, default_manager, dry_run=dry_run)
		if not ok:
			failures += 1

	if failures:
		print(f"platform bootstrap finished with {failures} failure(s).")
		return 1
	return 0


def _apply_envs(envs: Any) -> None:
	if not isinstance(envs, dict):
		return

	for key, value in envs.items():
		if isinstance(value, dict):
			_apply_envs(value)
			continue
		if not isinstance(key, str):
			continue
		if key.isdigit():
			continue
		os.environ[key] = os.path.expandvars(os.path.expanduser(str(value)))


def _normalize_package(item: Any) -> dict[str, Any] | None:
	if isinstance(item, str):
		return {
			"name": item
		}
	if not isinstance(item, dict):
		return None
	if "name" in item:
		return dict(item)
	if len(item) == 1:
		key = next(iter(item))
		value = item[key]
		pkg = dict(value) if isinstance(value, dict) else {}
		pkg["name"] = key
		return pkg
	return dict(item)


def _apply_package(pkg: dict[str, Any], default_manager: str, dry_run: bool = False) -> bool:
	name = str(pkg.get("name", "")).strip()
	if not name:
		return True

	manager = str(pkg.get("manager", default_manager)).strip().lower()
	action = str(pkg.get("action", "install")).strip().lower()
	command = pkg.get("command")

	if command:
		return _run_shell_command(str(command), dry_run=dry_run)

	if manager == "curl":
		url = str(pkg.get("curl_url") or pkg.get("url") or "").strip()
		if not url:
			print(f"warning: curl package without url: {name}")
			return False
		if action != "install":
			print(f"warning: unsupported curl action '{action}' for {name}; skipping")
			return True
		return _run_shell_command(f"curl -fsSL {shlex.quote(url)} | sh", dry_run=dry_run)

	cmd = _build_manager_cmd(manager, action, name, pkg)
	if not cmd:
		print(
			f"warning: unsupported manager/action for package '{name}' ({manager}/{action}); skipping")
		return True

	try:
		run(cmd, check=True, dry_run=dry_run)
		return True
	except Exception as exc:
		print(f"error: command failed for package '{name}': {exc}")
		return False


def _run_shell_command(command: str, dry_run: bool = False) -> bool:
	if os.name == "nt":
		shell_cmd = ["powershell", "-NoProfile", "-Command", command]
	else:
		shell_cmd = ["/bin/sh", "-lc", command]
	try:
		run(shell_cmd, check=True, dry_run=dry_run)
		return True
	except Exception as exc:
		print(f"error: shell command failed: {exc}")
		return False


def _build_manager_cmd(manager: str, action: str, name: str, pkg: dict[str, Any]) -> list[str]:
	if manager == "brew":
		if action == "install":
			return ["brew", "install", name]
		if action in {"remove", "uninstall"}:
			return ["brew", "uninstall", name]
		return []

	if manager == "brew-cask":
		if action == "install":
			return ["brew", "install", "--cask", name]
		if action in {"remove", "uninstall"}:
			return ["brew", "uninstall", "--cask", name]
		return []

	if manager == "apt":
		sudo = [] if _can_run_without_sudo() else ["sudo"]
		if action == "install":
			return [*sudo, "apt-get", "install", "-y", name]
		if action == "purge":
			return [*sudo, "apt-get", "purge", "-y", name]
		if action in {"remove", "uninstall"}:
			return [*sudo, "apt-get", "remove", "-y", name]
		return []

	if manager == "pkg":
		if action == "install":
			return ["pkg", "install", "-y", name]
		if action in {"remove", "uninstall"}:
			return ["pkg", "uninstall", "-y", name]
		return []

	if manager == "pip":
		if action == "install":
			return [sys.executable, "-m", "pip", "install", name]
		if action in {"remove", "uninstall"}:
			return [sys.executable, "-m", "pip", "uninstall", "-y", name]
		return []

	if manager == "go":
		version = str(pkg.get("version", "latest")).strip()
		suffix = f"@{version}" if "@" not in name else ""
		if action == "install":
			return ["go", "install", f"{name}{suffix}"]
		return []

	if manager == "npm":
		if action == "install":
			return ["npm", "install", "-g", name]
		if action in {"remove", "uninstall"}:
			return ["npm", "uninstall", "-g", name]
		return []

	if manager == "winget":
		if action == "install":
			return ["winget", "install", "--id", name]
		if action in {"remove", "uninstall"}:
			return ["winget", "uninstall", "--id", name]
		return []

	return []


def _can_run_without_sudo() -> bool:
	if os.name == "nt":
		return True
	if hasattr(os, "geteuid") and os.geteuid() == 0:
		return True
	return shutil.which("sudo") is None


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Run platform-specific bootstrap using config.yml.")
	parser.add_argument("config")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	raise SystemExit(platform_bootstrap(Path(args.config), dry_run=args.dry_run))
