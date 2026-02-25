#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
import re
import subprocess
import sys

__all__ = ["get_active_vscode_profile"]

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

	# Fallbacks uteis quando a plataforma nao foi detectada como esperado.
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
	# VS Code normalmente usa: "<arquivo> - <workspace> - <profile>".
	parts = [part.strip() for part in title.split(_TITLE_SEPARATOR) if part.strip()]
	if len(parts) >= 3:
		return parts[-1]
	if len(parts) == 2 and parts[-1] in known_profiles:
		return parts[-1]
	return default


def get_active_vscode_profile() -> str:
	"""Retorna o profile ativo do VS Code."""
	code_bin = "code"
	default = "Default"
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
