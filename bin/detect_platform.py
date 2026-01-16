#!/usr/bin/env python3
from __future__ import annotations

import os
import sys
from pathlib import Path


def detect_platform() -> str:
    prefix = os.environ.get("PREFIX", "")
    if os.environ.get("TERMUX_VERSION") or prefix.startswith("/data/data/com.termux"):
        return "termux"
    if sys.platform == "darwin":
        return "darwin"
    if sys.platform.startswith("linux"):
        try:
            version = Path("/proc/version").read_text().lower()
        except OSError:
            version = ""
        if "microsoft" in version or os.environ.get("WSL_DISTRO_NAME"):
            return "wsl"
        return "linux"
    return "unknown"


if __name__ == "__main__":
    print(detect_platform())
