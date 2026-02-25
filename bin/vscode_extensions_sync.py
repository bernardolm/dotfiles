#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys

from common import strip_trailing_commas, unique_strings
from json_util import strip_jsonc_comments
from vscode import default_code_cli_locations
from vscode_profile import get_active_vscode_profile, is_running_inside_vscode


_EXTENSION_ID_RE = re.compile(r"\b[a-z0-9][a-z0-9-]*\.[a-z0-9][a-z0-9-]*\b", re.IGNORECASE)
_ANSI_RESET = "\033[0m"
_ANSI_WHITE = "\033[37m"
_ANSI_GREEN = "\033[32m"
_ANSI_YELLOW = "\033[33m"
_ANSI_RED = "\033[31m"
_ANSI_BOLD = "\033[1m"
_COMMON_GROUP_NAMES = {"common", "default"}
_RESERVED_GROUP_NAMES = {"remove"}


def _load_group_extensions(data: dict[str, object], group_name: str, file_path: Path) -> list[str]:
	items = data.get(group_name, [])
	if items is None:
		return []
	if not isinstance(items, list):
		raise ValueError(f"'{group_name}' must be a list in {file_path}.")

	unique: list[str] = []
	seen: set[str] = set()
	for item in items:
		if not isinstance(item, str):
			continue
		ext = item.strip()
		if not ext or ext in seen:
			continue
		seen.add(ext)
		unique.append(ext)
	return unique


def load_extensions_config(file_path: Path) -> dict[str, object]:
	raw = file_path.read_text(encoding="utf-8")
	normalized = strip_trailing_commas(strip_jsonc_comments(raw))
	data = json.loads(normalized)
	if not isinstance(data, dict):
		raise ValueError(f"Invalid format in {file_path}: expected an object with extension groups.")
	return data


def _common_extensions_from_data(data: dict[str, object], file_path: Path) -> list[str]:
	common_extensions: list[str] = []
	seen: set[str] = set()
	for group_name, group_items in data.items():
		if not isinstance(group_items, list):
			continue
		if group_name.strip().lower() not in _COMMON_GROUP_NAMES:
			continue
		for ext in _load_group_extensions(data, group_name, file_path):
			if ext in seen:
				continue
			seen.add(ext)
			common_extensions.append(ext)
	return common_extensions


def _profile_extensions_from_data(data: dict[str, object], file_path: Path,
																	profile_name: str) -> list[str]:
	if profile_name in data:
		return _load_group_extensions(data, profile_name, file_path)
	return []


def _declared_extensions_from_data(data: dict[str, object], file_path: Path) -> set[str]:
	declared_extensions: set[str] = set()
	for group_name, group_items in data.items():
		if not isinstance(group_items, list):
			continue
		if group_name.strip().lower() in _RESERVED_GROUP_NAMES:
			continue
		declared_extensions.update(_load_group_extensions(data, group_name, file_path))
	return declared_extensions


def list_profile_sections(data: dict[str, object]) -> list[str]:
	profiles: list[str] = []
	seen: set[str] = set()
	for group_name, group_items in data.items():
		if not isinstance(group_items, list):
			continue
		name = group_name.strip()
		if not name:
			continue
		lowered = name.lower()
		if lowered in _COMMON_GROUP_NAMES or lowered in _RESERVED_GROUP_NAMES:
			continue
		if name in seen:
			continue
		seen.add(name)
		profiles.append(name)
	return profiles


def _with_profile_args(cmd: list[str], profile_name: str | None) -> list[str]:
	if not profile_name or not profile_name.strip():
		return list(cmd)
	return [*cmd, "--profile", profile_name.strip()]


def list_installed_extensions(code_bin: str, profile_name: str | None = None) -> set[str] | None:
	proc = subprocess.run(
		_with_profile_args([code_bin, "--list-extensions"], profile_name),
		capture_output=True,
		text=True,
	)
	if proc.returncode != 0:
		output = (proc.stderr or proc.stdout).strip()
		print("Warning: could not list installed extensions; removals will be attempted directly.")
		if output:
			print(f"  {output.splitlines()[-1]}")
		return None

	return {line.strip() for line in proc.stdout.splitlines() if line.strip()}


def parse_extension_action(raw_extension: str) -> tuple[str, str]:
	# Suffix "-" marks the extension for removal.
	if raw_extension.endswith("-"):
		return "remove", raw_extension[:-1].strip()
	return "install", raw_extension


def _style(text: str, *styles: str) -> str:
	return f"{''.join(styles)}{text}{_ANSI_RESET}"


def _status_color(status_kind: str) -> str:
	if status_kind == "success":
		return _ANSI_GREEN
	if status_kind == "warning":
		return _ANSI_YELLOW
	if status_kind == "error":
		return _ANSI_RED
	return _ANSI_WHITE


def _action_prefix(idx: int, total: int, action_label: str) -> str:
	prefix = _style(f"[{idx:02d}/{total}]", _ANSI_WHITE)
	action = _style(action_label, _ANSI_WHITE, _ANSI_BOLD)
	return f"{prefix} {action}:"


def _print_action_status(
	idx: int,
	total: int,
	action_label: str,
	extension: str,
	status_text: str,
	status_kind: str,
) -> None:
	colored = _style(f"{extension} - {status_text}", _status_color(status_kind))
	print(f"{_action_prefix(idx, total, action_label)} {colored}")


def _print_dependency_status(
	parent_extension: str,
	dependency_extension: str,
	status_text: str,
	status_kind: str,
) -> None:
	lead = _style(f"Removing dependency of extension {parent_extension}:", _ANSI_WHITE, _ANSI_BOLD)
	colored = _style(f"{dependency_extension} - {status_text}", _status_color(status_kind))
	print(f"    {lead} {colored}")


def dependency_blockers_from_error(output: str, target_extension: str) -> list[str]:
	if "depend" not in output.lower():
		return []

	target_key = target_extension.lower()
	seen: set[str] = set()
	blockers: list[str] = []
	for ext_id in _EXTENSION_ID_RE.findall(output):
		ext_key = ext_id.lower()
		if ext_key == target_key or ext_key in seen:
			continue
		seen.add(ext_key)
		blockers.append(ext_id)
	return blockers


def uninstall_extension_with_dependency_resolution(
	extension: str,
	code_bin: str,
	installed_extensions: set[str] | None,
	profile_name: str | None = None,
	visited: set[str] | None = None,
	parent_extension: str | None = None,
) -> tuple[bool, bool, str]:
	"""Return: (success, warning_not_installed, status_text)."""
	visited_path = set(visited or set())
	extension_key = extension.lower()
	if extension_key in visited_path:
		return False, False, f"FAILED (dependency cycle with {extension})"
	visited_path.add(extension_key)

	cmd = _with_profile_args([code_bin, "--uninstall-extension", extension], profile_name)
	proc = subprocess.run(cmd, capture_output=True, text=True)
	if proc.returncode == 0:
		if installed_extensions is not None:
			installed_extensions.discard(extension)
		return True, False, "OK"

	output = (proc.stderr or proc.stdout).strip()
	if "not installed" in output.lower():
		if installed_extensions is not None:
			installed_extensions.discard(extension)
		return True, True, "WARNING: extension was not installed"

	blockers = dependency_blockers_from_error(output, extension)
	if not blockers:
		last_line = output.splitlines()[-1] if output else ""
		status = f"FAILED (exit={proc.returncode})"
		if last_line:
			status = f"{status}: {last_line}"
		return False, False, status

	for blocker in blockers:
		blocker_success, blocker_warning, blocker_status = uninstall_extension_with_dependency_resolution(
			blocker,
			code_bin=code_bin,
			installed_extensions=installed_extensions,
			profile_name=profile_name,
			visited=visited_path,
			parent_extension=extension,
		)
		blocker_kind = "warning" if blocker_warning else ("success" if blocker_success else "error")
		_print_dependency_status(extension, blocker, blocker_status, blocker_kind)
		if not blocker_success:
			return False, False, f"FAILED (dependency not removed: {blocker})"

	retry_proc = subprocess.run(cmd, capture_output=True, text=True)
	if retry_proc.returncode == 0:
		if installed_extensions is not None:
			installed_extensions.discard(extension)
		return True, False, "OK"

	retry_output = (retry_proc.stderr or retry_proc.stdout).strip()
	if "not installed" in retry_output.lower():
		if installed_extensions is not None:
			installed_extensions.discard(extension)
		return True, True, "WARNING: extension was not installed"

	last_line = retry_output.splitlines()[-1] if retry_output else ""
	status = f"FAILED (exit={retry_proc.returncode})"
	if last_line:
		status = f"{status}: {last_line}"
	return False, False, status


def sync_extensions(
	extensions: list[str],
	code_bin: str,
	force: bool = True,
	dry_run: bool = False,
	profile_name: str | None = None,
	installed_extensions: set[str] | None = None,
) -> int:
	failures: list[str] = []
	warnings: list[str] = []
	total = len(extensions)
	if dry_run:
		installed_extensions = None
	elif installed_extensions is None:
		installed_extensions = list_installed_extensions(code_bin, profile_name=profile_name)
	else:
		installed_extensions = set(installed_extensions)
	install_count = 0
	remove_count = 0

	for idx, raw_ext in enumerate(extensions, start=1):
		action, ext = parse_extension_action(raw_ext)
		if not ext:
			warnings.append(raw_ext)
			prefix = _style(f"[{idx:02d}/{total}]", _ANSI_WHITE)
			message = _style(f"WARNING: invalid entry '{raw_ext}', skipping.", _ANSI_YELLOW)
			print(f"{prefix} {message}")
			continue

		action_label = "Removing" if action == "remove" else "Installing"

		if action == "remove":
			remove_count += 1
			if installed_extensions is not None and ext not in installed_extensions:
				warnings.append(ext)
				_print_action_status(
					idx,
					total,
					action_label,
					ext,
					"WARNING: extension was not installed",
					"warning",
				)
				continue
			if dry_run:
				cmd = _with_profile_args([code_bin, "--uninstall-extension", ext], profile_name)
				if os.name == "nt":
					printable_cmd = subprocess.list2cmdline(cmd)
				else:
					printable_cmd = shlex.join(cmd)
				_print_action_status(idx, total, action_label, ext, "DRY-RUN", "info")
				print(f"  {printable_cmd}")
				continue

			remove_success, remove_warning, remove_status = uninstall_extension_with_dependency_resolution(
				ext,
				code_bin=code_bin,
				installed_extensions=installed_extensions,
				profile_name=profile_name,
			)
			if remove_success:
				if remove_warning:
					warnings.append(ext)
				_print_action_status(
					idx,
					total,
					action_label,
					ext,
					remove_status,
					"warning" if remove_warning else "success",
				)
				continue

			failures.append(ext)
			_print_action_status(idx, total, action_label, ext, remove_status, "error")
			continue

		install_count += 1
		cmd = _with_profile_args([code_bin, "--install-extension", ext], profile_name)
		if force:
			cmd.append("--force")

		if dry_run:
			if os.name == "nt":
				printable_cmd = subprocess.list2cmdline(cmd)
			else:
				printable_cmd = shlex.join(cmd)
			_print_action_status(idx, total, action_label, ext, "DRY-RUN", "info")
			print(f"  {printable_cmd}")
			continue

		proc = subprocess.run(cmd, capture_output=True, text=True)
		if proc.returncode == 0:
			if action == "remove" and installed_extensions is not None:
				installed_extensions.discard(ext)
			if action == "install" and installed_extensions is not None:
				installed_extensions.add(ext)
			_print_action_status(idx, total, action_label, ext, "OK", "success")
			continue

		failures.append(ext)
		output = (proc.stderr or proc.stdout).strip()
		last_line = output.splitlines()[-1] if output else ""
		status = f"FAILED (exit={proc.returncode})"
		if last_line:
			status = f"{status}: {last_line}"
		_print_action_status(idx, total, action_label, ext, status, "error")

	print("")
	print(f"Total: {total}")
	print(f"Installations: {install_count}")
	print(f"Removals: {remove_count}")
	print(f"Warnings: {len(warnings)}")
	print(f"Success: {total - len(failures)}")
	print(f"Failures: {len(failures)}")
	if failures:
		print("Extensions with failures:")
		for ext in failures:
			print(f"- {ext}")
		return 1
	return 0


def detect_code_binary(provided: str | None) -> str | None:
	if provided:
		resolved = shutil.which(provided)
		if resolved:
			return resolved

		provided_path = Path(provided).expanduser()
		if provided_path.is_file():
			return str(provided_path)
		return None

	for candidate in ("code", "code-insiders", "codium"):
		resolved = shutil.which(candidate)
		if resolved:
			return resolved

	for candidate in default_code_cli_locations():
		if candidate.is_file():
			return str(candidate)
	return None


def main(
	extensions_file: str | Path | None = None,
	profile_name: str | None = None,
	code_bin: str | None = None,
	force: bool | None = None,
	dry_run: bool | None = None,
) -> int:
	default_extensions_file = Path.home() / "dotfiles" / "ui" / "vscode" / "extensions.jsonc"
	resolved_extensions_file = Path(extensions_file or default_extensions_file).expanduser()
	explicit_profile_name = profile_name.strip() if profile_name and profile_name.strip() else None
	resolved_code_bin = detect_code_binary(code_bin)
	resolved_force = True if force is None else force
	resolved_dry_run = False if dry_run is None else dry_run

	code_bin = resolved_code_bin
	if not code_bin:
		print("VS Code CLI not found. Add 'code' to PATH.")
		return 2

	extensions_file = resolved_extensions_file
	if not extensions_file.exists():
		print(f"File not found: {extensions_file}")
		return 2

	try:
		config_data = load_extensions_config(extensions_file)
	except (OSError, json.JSONDecodeError, ValueError) as exc:
		print(f"Failed to load extensions from {extensions_file}: {exc}")
		return 2

	common_extensions = _common_extensions_from_data(config_data, extensions_file)
	profile_sections = list_profile_sections(config_data)
	declared_extensions = _declared_extensions_from_data(config_data, extensions_file)
	inside_vscode = is_running_inside_vscode()
	stage2_profiles: list[str] = []
	if explicit_profile_name:
		stage2_profiles = [explicit_profile_name]
	elif inside_vscode:
		active_profile = get_active_vscode_profile()
		stage2_profiles = [active_profile]
	else:
		stage2_profiles = profile_sections
	stage2_profiles = unique_strings(stage2_profiles)

	install_targets: list[tuple[str, str,
															list[str]]] = [("Default", "common/default", common_extensions)]
	for profile_name in stage2_profiles:
		profile_actions = _profile_extensions_from_data(config_data, extensions_file, profile_name)
		install_targets.append((profile_name, "profile-specific", profile_actions))

	overall_status = 0
	for idx, (target_profile, mode, install_extensions) in enumerate(install_targets, start=1):
		if len(install_targets) > 1:
			if idx > 1:
				print("")
			header = _style(
				f"Synchronizing profile [{idx}/{len(install_targets)}]: {target_profile} ({mode})",
				_ANSI_WHITE,
				_ANSI_BOLD,
			)
			print(header)

		if not install_extensions:
			print(f"No extensions to install for profile '{target_profile}' in: {extensions_file}")
			continue

		run_status = sync_extensions(
			install_extensions,
			code_bin=code_bin,
			force=resolved_force,
			dry_run=resolved_dry_run,
			profile_name=target_profile,
			installed_extensions=set(),
		)
		if run_status != 0:
			overall_status = run_status

	cleanup_profiles = unique_strings(["Default", *stage2_profiles])
	if cleanup_profiles:
		print("")
		header = _style("Final cleanup: removing extensions not declared in extensions.jsonc",
										_ANSI_WHITE, _ANSI_BOLD)
		print(header)
	for cleanup_profile in cleanup_profiles:
		installed_extensions = list_installed_extensions(code_bin, profile_name=cleanup_profile)
		if installed_extensions is None:
			overall_status = 1
			continue

		remove_actions = [f"{ext}-" for ext in sorted(installed_extensions - declared_extensions)]
		if not remove_actions:
			print(f"Profile '{cleanup_profile}': no undeclared extensions to remove.")
			continue

		print("")
		profile_header = _style(f"Cleanup profile: {cleanup_profile}", _ANSI_WHITE, _ANSI_BOLD)
		print(profile_header)
		run_status = sync_extensions(
			remove_actions,
			code_bin=code_bin,
			force=resolved_force,
			dry_run=resolved_dry_run,
			profile_name=cleanup_profile,
			installed_extensions=installed_extensions,
		)
		if run_status != 0:
			overall_status = run_status

	return overall_status


def _parse_cli_profile(argv: list[str]) -> str | None:
	parser = argparse.ArgumentParser(
		prog="bin/vscode_extensions_sync.py",
		description="Synchronize VS Code extensions for one or more profiles.",
		add_help=False,
	)
	parser.add_argument(
		"--profile",
		dest="profile_flag",
		help="Synchronize only the provided VS Code profile.",
	)
	parser.add_argument(
		"profile_name",
		nargs="?",
		help="Deprecated positional profile name. Prefer --profile.",
	)
	args = parser.parse_args(argv)

	profile_flag = args.profile_flag.strip() if args.profile_flag else None
	positional_profile = args.profile_name.strip() if args.profile_name else None
	if profile_flag and positional_profile and profile_flag != positional_profile:
		parser.error("Use either --profile or a positional profile name, not conflicting values.")
	return profile_flag or positional_profile


if __name__ == "__main__":
	override_profile = _parse_cli_profile(sys.argv[1:])
	raise SystemExit(main(profile_name=override_profile))
