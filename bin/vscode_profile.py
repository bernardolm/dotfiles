#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys


__all__ = ["get_active_vscode_profile", "is_running_inside_vscode"]

_WINDOW_PROCESS_RE = re.compile(r"window(?:\s+\[\d+\])?\s+\((?P<title>.+)\)$", re.IGNORECASE)
_WINDOW_STATS_RE = re.compile(r"^\|\s+Window\s+\((?P<title>.+)\)$")
_TITLE_SEPARATOR = " \u2014 "


def _iter_window_titles(status_output: str) -> list[str]:
	titles: list[str] = []
	for raw_line in status_output.splitlines():
		line = raw_line.strip()
		if not line:
			continue

		process_match = _WINDOW_PROCESS_RE.search(line)
		if process_match:
			titles.append(process_match.group("title").strip())
			continue

		stats_match = _WINDOW_STATS_RE.match(line)
		if stats_match:
			titles.append(stats_match.group("title").strip())

	return titles


def _profile_sync_paths() -> list[Path]:
	paths: list[Path] = []
	home = Path.home()
	appdata = os.environ.get("APPDATA")

	if sys.platform == "darwin":
		paths.append(home / "Library/Application Support/Code/User/sync/profiles/lastSyncprofiles.json")
	if sys.platform.startswith("linux"):
		paths.append(home / ".config/Code/User/sync/profiles/lastSyncprofiles.json")
	if os.name == "nt" and appdata:
		paths.append(Path(appdata) / "Code/User/sync/profiles/lastSyncprofiles.json")

	# Useful fallbacks when platform detection does not behave as expected.
	paths.append(home / "Library/Application Support/Code/User/sync/profiles/lastSyncprofiles.json")
	paths.append(home / ".config/Code/User/sync/profiles/lastSyncprofiles.json")

	unique: list[Path] = []
	seen: set[Path] = set()
	for path in paths:
		if path in seen:
			continue
		seen.add(path)
		unique.append(path)
	return unique


def _known_profile_names() -> set[str]:
	for path in _profile_sync_paths():
		if not path.is_file():
			continue

		try:
			payload = json.loads(path.read_text(encoding="utf-8"))
		except (OSError, UnicodeDecodeError, json.JSONDecodeError):
			continue

		content = payload.get("syncData", {}).get("content")
		if not isinstance(content, str):
			continue

		try:
			profiles = json.loads(content)
		except json.JSONDecodeError:
			continue

		names = {
			item["name"].strip()
			for item in profiles
			if isinstance(item, dict) and isinstance(item.get("name"), str) and item["name"].strip()
		}
		if names:
			return names

	return set()


def _profile_from_title(title: str, default: str, known_profiles: set[str]) -> str:
	# VS Code usually uses: "<file> - <workspace> - <profile>".
	parts = [part.strip() for part in title.split(_TITLE_SEPARATOR) if part.strip()]
	if len(parts) >= 3:
		return parts[-1]
	if len(parts) == 2 and parts[-1] in known_profiles:
		return parts[-1]
	return default


def is_running_inside_vscode() -> bool:
	return bool(os.environ.get("VSCODE_PID", "").strip())


def _argv_from_pid(pid: int) -> list[str]:
	proc_cmdline = Path(f"/proc/{pid}/cmdline")
	if proc_cmdline.is_file():
		try:
			raw = proc_cmdline.read_bytes()
		except OSError:
			raw = b""
		if raw:
			return [part.decode("utf-8", errors="ignore") for part in raw.split(b"\0") if part]

	proc = subprocess.run(
		["ps", "-p", str(pid), "-o", "command="],
		capture_output=True,
		text=True,
		check=False,
	)
	if proc.returncode != 0:
		return []

	command_line = proc.stdout.strip()
	if not command_line:
		return []

	try:
		return shlex.split(command_line)
	except ValueError:
		return command_line.split()


def _profile_from_vscode_pid(default: str) -> str | None:
	raw_pid = os.environ.get("VSCODE_PID", "").strip()
	if not raw_pid:
		return None

	try:
		pid = int(raw_pid)
	except ValueError:
		return default

	argv = _argv_from_pid(pid)
	if not argv:
		return default

	for idx, arg in enumerate(argv):
		if arg == "--profile" and idx + 1 < len(argv):
			candidate = argv[idx + 1].strip()
			return candidate or default
		if arg.startswith("--profile="):
			candidate = arg.split("=", 1)[1].strip()
			return candidate or default
	return default


def get_active_vscode_profile() -> str:
	"""Return the active VS Code profile."""
	code_bin = "code"
	default = "Default"

	profile_from_pid = _profile_from_vscode_pid(default)
	if profile_from_pid is not None:
		return profile_from_pid

	try:
		proc = subprocess.run([code_bin, "--status"], capture_output=True, text=True, check=False)
	except FileNotFoundError:
		return default

	if proc.returncode != 0:
		return default

	titles = _iter_window_titles(proc.stdout)
	if not titles:
		return default

	known_profiles = _known_profile_names()
	return _profile_from_title(titles[0], default=default, known_profiles=known_profiles)


if __name__ == "__main__":
	print(get_active_vscode_profile())
