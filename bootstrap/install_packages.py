#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.bootstrap_flow import bootstrap_flow

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Install packages via bootstrap flow.")
	parser.add_argument("--profile", choices=["desktop", "server"], default=None)
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	raise SystemExit(
		bootstrap_flow(install_packages=True, link=False, profile=args.profile, dry_run=args.dry_run))
