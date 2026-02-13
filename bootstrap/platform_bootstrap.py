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
from bootstrap.repo_root import repo_root
from bootstrap.run import run


_PACKAGE_OPTION_KEYS = {
	"name",
	"action",
	"manager",
	"command",
	"curl_url",
	"url",
	"dest",
	"version",
	"profiles",
	"exclude_profiles",
	"platforms",
	"exclude_platforms",
	"file",
	"optional",
	"classic",
}


def platform_bootstrap(
	config_path: Path,
	dry_run: bool = False,
	profile: str | None = None,
	platform_name: str | None = None,
) -> int:
	if not config_path.exists():
		print(f"config not found: {config_path}")
		return 1

	config = load_config(config_path)
	if not isinstance(config, dict):
		print(f"invalid config format: {config_path}")
		return 1

	resolved_profile = (profile or os.environ.get("DOTFILES_PROFILE", "desktop")).strip().lower()
	resolved_platform = (platform_name or os.environ.get("DOTFILES_PLATFORM", "")).strip().lower()

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
		if not _is_package_enabled(pkg, profile=resolved_profile, platform_name=resolved_platform):
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

	pkg = dict(item)
	if "name" in pkg:
		pkg["name"] = str(pkg["name"]).strip()
		return pkg

	package_keys: list[tuple[str, Any]] = []
	for raw_key in pkg.keys():
		key = str(raw_key).strip()
		if key.lower() in _PACKAGE_OPTION_KEYS:
			continue
		package_keys.append((key, raw_key))

	if len(package_keys) == 1:
		package_name, raw_package_key = package_keys[0]
		package_value = pkg.pop(raw_package_key, None)
		normalized: dict[str, Any] = {}
		if isinstance(package_value, dict):
			normalized.update(package_value)
		normalized.update(pkg)
		normalized["name"] = package_name
		return normalized

	return pkg


def _is_package_enabled(pkg: dict[str, Any], profile: str, platform_name: str) -> bool:
	profiles = _to_str_set(pkg.get("profiles"))
	exclude_profiles = _to_str_set(pkg.get("exclude_profiles"))
	platforms = _to_str_set(pkg.get("platforms"))
	exclude_platforms = _to_str_set(pkg.get("exclude_platforms"))

	if profiles and profile not in profiles:
		return False
	if profile in exclude_profiles:
		return False

	if platforms and platform_name and platform_name not in platforms:
		return False
	if platform_name and platform_name in exclude_platforms:
		return False

	return True


def _to_str_set(value: Any) -> set[str]:
	if value is None:
		return set()
	if isinstance(value, str):
		item = value.strip()
		if not item:
			return set()
		if item.startswith("[") and item.endswith("]"):
			inner = item[1:-1].strip()
			if not inner:
				return set()
			result: set[str] = set()
			for part in inner.split(","):
				text = part.strip().strip('"').strip("'").lower()
				if text:
					result.add(text)
			return result
		return {item.lower()}
	if isinstance(value, (list, tuple, set)):
		result: set[str] = set()
		for item in value:
			text = str(item).strip().lower()
			if text:
				result.add(text)
		return result
	return set()


def _apply_package(pkg: dict[str, Any], default_manager: str, dry_run: bool = False) -> bool:
	optional = _to_bool(pkg.get("optional"))
	command = pkg.get("command")
	if command:
		ok = _run_shell_command(str(command), dry_run=dry_run)
		return _finalize_result(ok, label="command", optional=optional)

	name = str(pkg.get("name", "")).strip()
	if not name:
		return True

	manager = str(pkg.get("manager", default_manager)).strip().lower()
	action = str(pkg.get("action", "install")).strip().lower()

	if manager == "curl":
		url = str(pkg.get("curl_url") or pkg.get("url") or "").strip()
		if not url:
			print(f"warning: curl package without url: {name}")
			return _finalize_result(False, label=name, optional=optional)
		if action != "install":
			print(f"warning: unsupported curl action '{action}' for {name}; skipping")
			return True
		ok = _run_shell_command(f"curl -fsSL {shlex.quote(url)} | sh", dry_run=dry_run)
		return _finalize_result(ok, label=name, optional=optional)

	if manager in {"go-list", "go-packages"}:
		ok = _apply_go_packages_file(pkg, dry_run=dry_run)
		return _finalize_result(ok, label=name, optional=optional)

	if manager in {"pip-requirements", "python-requirements"}:
		ok = _apply_pip_requirements_file(pkg, dry_run=dry_run)
		return _finalize_result(ok, label=name, optional=optional)

	if manager == "git":
		ok = _apply_git_package(name, pkg, action=action, dry_run=dry_run)
		return _finalize_result(ok, label=name, optional=optional)

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
		return _finalize_result(False, label=name, optional=optional)


def _finalize_result(ok: bool, label: str, optional: bool) -> bool:
	if ok:
		return True
	if optional:
		print(f"warning: optional package failed or skipped: {label}")
		return True
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


def _apply_go_packages_file(pkg: dict[str, Any], dry_run: bool = False) -> bool:
	file_value = str(pkg.get("file", "terminal/go/packages.txt")).strip()
	file_path = _resolve_package_file(file_value)
	if not file_path.exists():
		print(f"warning: go package file not found: {file_path}")
		return False

	if shutil.which("go") is None:
		print("warning: go executable not found; cannot install go package list.")
		return False

	for module in _read_package_list(file_path):
		try:
			run(["go", "install", module], check=True, dry_run=dry_run)
		except Exception as exc:
			print(f"error: go install failed for '{module}': {exc}")
			return False
	return True


def _apply_pip_requirements_file(pkg: dict[str, Any], dry_run: bool = False) -> bool:
	file_value = str(pkg.get("file", "terminal/python/requirements.txt")).strip()
	file_path = _resolve_package_file(file_value)
	if not file_path.exists():
		print(f"warning: python requirements file not found: {file_path}")
		return False

	try:
		run([sys.executable, "-m", "pip", "install", "-r", str(file_path)], check=True, dry_run=dry_run)
		return True
	except Exception as exc:
		print(f"error: pip requirements install failed for '{file_path}': {exc}")
		return False


def _resolve_package_file(value: str) -> Path:
	path = Path(os.path.expandvars(os.path.expanduser(value)))
	if path.is_absolute():
		return path
	return repo_root() / path


def _read_package_list(path: Path) -> list[str]:
	items: list[str] = []
	for raw_line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
		line = raw_line.strip()
		if not line or line.startswith("#"):
			continue
		items.append(line)
	return items


def _apply_git_package(name: str, pkg: dict[str, Any], action: str, dry_run: bool = False) -> bool:
	if action in {"remove", "uninstall"}:
		print(f"warning: git uninstall is not supported for {name}; skipping")
		return True
	if action != "install":
		print(f"warning: unsupported git action '{action}' for {name}; skipping")
		return True

	url = str(pkg.get("url", "")).strip()
	if not url:
		print(f"warning: git package without url: {name}")
		return False

	dest_raw = str(pkg.get("dest", "")).strip()
	dest = _expand_dest_path(dest_raw) if dest_raw else (Path.home() / ".local/src" / name)

	try:
		if dest.exists():
			git_dir = dest / ".git"
			if not git_dir.exists():
				print(f"warning: destination exists but is not a git repository: {dest}")
				return False
			run(["git", "-C", str(dest), "pull", "--ff-only"], check=True, dry_run=dry_run)
			return True

		run(["git", "clone", url, str(dest)], check=True, dry_run=dry_run)
		return True
	except Exception as exc:
		print(f"error: git command failed for package '{name}': {exc}")
		return False


def _expand_dest_path(value: str) -> Path:
	expanded = os.path.expanduser(os.path.expandvars(value))
	return Path(expanded)


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

	if manager == "snap":
		sudo = [] if _can_run_without_sudo() else ["sudo"]
		if action == "install":
			classic = _to_bool(pkg.get("classic"))
			args = [*sudo, "snap", "install", name]
			if classic:
				args.append("--classic")
			return args
		if action in {"remove", "uninstall"}:
			return [*sudo, "snap", "remove", name]
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
		base = ["winget"]
		if action == "install":
			return [
				*base,
				"install",
				"--id",
				name,
				"--accept-source-agreements",
				"--accept-package-agreements",
			]
		if action in {"remove", "uninstall"}:
			return [*base, "uninstall", "--id", name]
		return []

	if manager == "mas":
		if action == "install":
			return ["mas", "install", name]
		if action in {"remove", "uninstall"}:
			return ["mas", "uninstall", name]
		return []

	return []


def _to_bool(value: Any, default: bool = False) -> bool:
	if isinstance(value, bool):
		return value
	if value is None:
		return default
	text = str(value).strip().lower()
	if text in {"1", "true", "yes", "y", "on"}:
		return True
	if text in {"0", "false", "no", "n", "off"}:
		return False
	return default


def _can_run_without_sudo() -> bool:
	if os.name == "nt":
		return True
	if hasattr(os, "geteuid") and os.geteuid() == 0:
		return True
	return shutil.which("sudo") is None


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Run platform-specific bootstrap using config.yml.")
	parser.add_argument("config")
	parser.add_argument("--profile", default=os.environ.get("DOTFILES_PROFILE", "desktop"))
	parser.add_argument("--platform", default=os.environ.get("DOTFILES_PLATFORM", ""))
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	raise SystemExit(
		platform_bootstrap(
			Path(args.config),
			dry_run=args.dry_run,
			profile=args.profile,
			platform_name=args.platform,
		))
