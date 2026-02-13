#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.bootstrap_flow import main as bootstrap_flow_main

if __name__ == "__main__":
	raise SystemExit(bootstrap_flow_main())
