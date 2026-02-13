#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import socket
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.detect_platform import detect_platform
from bootstrap.repo_root import repo_root


VALID_PROFILES = {"desktop", "server"}


def resolve_profile(profile: str | None, platform_name: str | None = None) -> str:
	value = (profile or os.environ.get("DOTFILES_PROFILE", "")).strip().lower()

	resolved_platform = (platform_name or os.environ.get("DOTFILES_PLATFORM", "")).strip().lower()
	if not resolved_platform:
		resolved_platform = detect_platform()

	if value:
		if value not in VALID_PROFILES:
			raise ValueError(f"invalid profile: {value}")
		if resolved_platform in {"alpine", "ubuntu"}:
			return "server"
		return value

	if resolved_platform in {"alpine", "ubuntu"}:
		return "server"

	if resolved_platform == "linux" and not _has_graphical_session():
		return "server"

	return "desktop"


def select_config_path(platform_name: str, profile: str, host: str | None = None) -> Path:
	base = repo_root() / "bootstrap" / platform_name
	hostname = normalized_hostname(host)

	candidates = [
		base / f"{hostname}.{profile}.config.yml",
		base / f"{hostname}.config.yml",
		base / f"{profile}.config.yml",
		base / "config.yml",
	]
	for item in candidates:
		if item.exists():
			return item
	return candidates[-1]


def normalized_hostname(host: str | None = None) -> str:
	resolved = (host or os.environ.get("DOTFILES_HOST", "")).strip()
	if not resolved:
		resolved = socket.gethostname().strip()
	resolved = resolved.split(".", 1)[0].strip().lower()
	if not resolved:
		return "default"
	return "".join(ch if ch.isalnum() or ch in {"-", "_"} else "-" for ch in resolved)


def _has_graphical_session() -> bool:
	if os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY"):
		return True
	session_type = os.environ.get("XDG_SESSION_TYPE", "").strip().lower()
	return session_type in {"x11", "wayland"}
