#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


def detect_platform() -> str:
	prefix = os.environ.get("PREFIX", "")
	if os.environ.get("TERMUX_VERSION") or prefix.startswith("/data/data/com.termux"):
		return "termux"

	if sys.platform == "darwin":
		return "darwin"
	if sys.platform in {"win32", "cygwin"}:
		return "windows"
	if not sys.platform.startswith("linux"):
		return "unknown"

	if _is_wsl():
		return "wsl"

	os_release = _read_os_release()
	os_id = os_release.get("ID", "").lower()
	os_like = os_release.get("ID_LIKE", "").lower()
	if os_id == "alpine" or "alpine" in os_like:
		return "alpine"
	if os_id in {"ubuntu", "debian"} or any(part in {"ubuntu", "debian"} for part in os_like.split()):
		return "ubuntu"
	return "linux"


def _is_wsl() -> bool:
	if os.environ.get("WSL_DISTRO_NAME"):
		return True
	try:
		version = Path("/proc/version").read_text(encoding="utf-8", errors="ignore").lower()
	except OSError:
		return False
	return "microsoft" in version


def _read_os_release() -> dict[str, str]:
	path = Path("/etc/os-release")
	if not path.exists():
		return {}

	data: dict[str, str] = {}
	for raw in path.read_text(encoding="utf-8", errors="ignore").splitlines():
		line = raw.strip()
		if not line or line.startswith("#") or "=" not in line:
			continue
		key, value = line.split("=", 1)
		value = value.strip().strip('"').strip("'")
		data[key.strip()] = value
	return data


if __name__ == "__main__":
	print(detect_platform())
