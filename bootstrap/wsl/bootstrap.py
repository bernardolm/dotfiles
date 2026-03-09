#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.platform_entrypoint import run_platform_entrypoint

if __name__ == "__main__":
	raise SystemExit(run_platform_entrypoint("wsl", "WSL bootstrap."))
