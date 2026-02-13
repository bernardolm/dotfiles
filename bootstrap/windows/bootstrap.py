#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from dotfiles_tools.platform_bootstrap import platform_bootstrap  # noqa: E402

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Windows bootstrap.")
	parser.add_argument("--dry-run", action="store_true")
	args = parser.parse_args()

	config_path = Path(__file__).with_name("config.yml")
	raise SystemExit(platform_bootstrap(config_path, dry_run=args.dry_run))
