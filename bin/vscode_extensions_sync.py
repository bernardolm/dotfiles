#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
import platform
import re
import shlex
import shutil
import subprocess
import sys

from common import is_truthy
from vscode_profile import get_active_vscode_profile

_EXTENSION_ID_RE = re.compile(r"\b[a-z0-9][a-z0-9-]*\.[a-z0-9][a-z0-9-]*\b", re.IGNORECASE)
_ANSI_RESET = "\033[0m"
_ANSI_WHITE = "\033[37m"
_ANSI_GREEN = "\033[32m"
_ANSI_YELLOW = "\033[33m"
_ANSI_RED = "\033[31m"
_ANSI_BOLD = "\033[1m"


def strip_jsonc_comments(content: str) -> str:
	result: list[str] = []
	in_string = False
	escaped = False
	i = 0

	while i < len(content):
		ch = content[i]
		nxt = content[i + 1] if i + 1 < len(content) else ""

		if in_string:
			result.append(ch)
			if escaped:
				escaped = False
			elif ch == "\\":
				escaped = True
			elif ch == '"':
				in_string = False
			i += 1
			continue

		if ch == '"':
			in_string = True
			result.append(ch)
			i += 1
			continue

		if ch == "/" and nxt == "/":
			i += 2
			while i < len(content) and content[i] != "\n":
				i += 1
			continue

		if ch == "/" and nxt == "*":
			i += 2
			while i + 1 < len(content) and not (content[i] == "*" and content[i + 1] == "/"):
				i += 1
			i += 2
			continue

		result.append(ch)
		i += 1

	return "".join(result)


def strip_trailing_commas(content: str) -> str:
	result: list[str] = []
	in_string = False
	escaped = False
	i = 0

	while i < len(content):
		ch = content[i]

		if in_string:
			result.append(ch)
			if escaped:
				escaped = False
			elif ch == "\\":
				escaped = True
			elif ch == '"':
				in_string = False
			i += 1
			continue

		if ch == '"':
			in_string = True
			result.append(ch)
			i += 1
			continue

		if ch == ",":
			j = i + 1
			while j < len(content) and content[j].isspace():
				j += 1
			if j < len(content) and content[j] in "]}":
				i += 1
				continue

		result.append(ch)
		i += 1

	return "".join(result)


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


def load_extensions(file_path: Path, profile_name: str) -> list[str]:
	raw = file_path.read_text(encoding="utf-8")
	normalized = strip_trailing_commas(strip_jsonc_comments(raw))
	data = json.loads(normalized)

	if not isinstance(data, dict):
		raise ValueError(
			f"Invalid format in {file_path}: expected an object with extension groups.")

	common_extensions = _load_group_extensions(data, "common", file_path)
	profile_extensions = []
	if profile_name in data:
		profile_extensions = _load_group_extensions(data, profile_name, file_path)
	remove_extensions = _load_group_extensions(data, "remove", file_path)

	install_actions: list[str] = []
	install_seen: set[str] = set()
	for ext in [*common_extensions, *profile_extensions]:
		if ext in install_seen:
			continue
		install_seen.add(ext)
		install_actions.append(ext)

	remove_actions: list[str] = []
	remove_seen: set[str] = set()
	for ext in remove_extensions:
		if ext in remove_seen:
			continue
		remove_seen.add(ext)
		remove_actions.append(f"{ext}-")

	return [*install_actions, *remove_actions]


def list_installed_extensions(code_bin: str) -> set[str] | None:
	proc = subprocess.run([code_bin, "--list-extensions"], capture_output=True, text=True)
	if proc.returncode != 0:
		output = (proc.stderr or proc.stdout).strip()
		print(
			"Warning: could not list installed extensions; removals will be attempted directly.")
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
	visited: set[str] | None = None,
	parent_extension: str | None = None,
) -> tuple[bool, bool, str]:
	"""Return: (success, warning_not_installed, status_text)."""
	visited_path = set(visited or set())
	extension_key = extension.lower()
	if extension_key in visited_path:
		return False, False, f"FAILED (dependency cycle with {extension})"
	visited_path.add(extension_key)

	cmd = [code_bin, "--uninstall-extension", extension]
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


def sync_extensions(extensions: list[str],
										code_bin: str,
										force: bool = True,
										dry_run: bool = False) -> int:
	failures: list[str] = []
	warnings: list[str] = []
	total = len(extensions)
	installed_extensions = None if dry_run else list_installed_extensions(code_bin)
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
				cmd = [code_bin, "--uninstall-extension", ext]
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
		else:
			install_count += 1
			cmd = [code_bin, "--install-extension", ext]
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


def default_code_cli_locations() -> list[Path]:
	os_name = platform.system().lower()
	locations: list[Path] = []

	if os_name == "windows":
		env_paths = [
			os.environ.get("LOCALAPPDATA"),
			os.environ.get("PROGRAMFILES"),
			os.environ.get("PROGRAMFILES(X86)"),
		]
		suffixes = [
			Path("Programs/Microsoft VS Code/bin/code.cmd"),
			Path("Programs/Microsoft VS Code Insiders/bin/code-insiders.cmd"),
			Path("VSCodium/bin/codium.cmd"),
			Path("Microsoft VS Code/bin/code.cmd"),
			Path("Microsoft VS Code Insiders/bin/code-insiders.cmd"),
		]
		for base in env_paths:
			if not base:
				continue
			base_path = Path(base)
			for suffix in suffixes:
				locations.append(base_path / suffix)
		return locations

	if os_name == "darwin":
		locations.extend([
			Path("/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"),
			Path(
				"/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"),
			Path("/Applications/VSCodium.app/Contents/Resources/app/bin/codium"),
			Path.home() / "Applications/Visual Studio Code.app/Contents/Resources/app/bin/code",
			Path.home() /
			"Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders",
			Path.home() / "Applications/VSCodium.app/Contents/Resources/app/bin/codium",
		])
		return locations

	locations.extend([
		Path("/usr/bin/code"),
		Path("/usr/bin/code-insiders"),
		Path("/usr/bin/codium"),
		Path("/snap/bin/code"),
		Path("/snap/bin/code-insiders"),
		Path("/snap/bin/codium"),
	])
	return locations


def main(
	extensions_file: str | Path | None = None,
	profile_name: str | None = None,
	code_bin: str | None = None,
	force: bool | None = None,
	dry_run: bool | None = None,
) -> int:
	default_extensions_file = Path(__file__).resolve().parents[1] / "ui" / "vscode" / "extensions.jsonc"
	resolved_extensions_file = Path(extensions_file or os.environ.get(
		"DOTFILES_VSCODE_EXTENSIONS_FILE", str(default_extensions_file))).expanduser()
	resolved_profile_name = profile_name.strip() if profile_name and profile_name.strip() else get_active_vscode_profile()
	resolved_code_bin = detect_code_binary(code_bin or os.environ.get("DOTFILES_VSCODE_CODE_BIN"))
	resolved_force = force
	if resolved_force is None:
		resolved_force = not is_truthy(os.environ.get("DOTFILES_VSCODE_NO_FORCE", "0"))
	resolved_dry_run = dry_run if dry_run is not None else is_truthy(
		os.environ.get("DOTFILES_DRY_RUN") or os.environ.get("DOTFILES_VSCODE_DRY_RUN", "0"))

	code_bin = resolved_code_bin
	if not code_bin:
		print(
			"VS Code CLI not found. Set DOTFILES_VSCODE_CODE_BIN or add 'code' to PATH.")
		return 2

	extensions_file = resolved_extensions_file
	if not extensions_file.exists():
		print(f"File not found: {extensions_file}")
		return 2

	try:
		extensions = load_extensions(extensions_file, profile_name=resolved_profile_name)
	except (OSError, json.JSONDecodeError, ValueError) as exc:
		print(f"Failed to load extensions from {extensions_file}: {exc}")
		return 2

	if not extensions:
		print(f"No extensions found in: {extensions_file}")
		return 0

	return sync_extensions(
		extensions,
		code_bin=code_bin,
		force=resolved_force,
		dry_run=resolved_dry_run,
	)


if __name__ == "__main__":
	if len(sys.argv) > 2:
		print("Usage: bin/vscode_extensions_sync.py [profileName]")
		raise SystemExit(2)

	override_profile = sys.argv[1] if len(sys.argv) == 2 else None
	raise SystemExit(main(profile_name=override_profile))
