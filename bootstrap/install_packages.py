#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bin.common import dotfiles_dry_run
from bootstrap.bootstrap_flow import bootstrap_flow


def main() -> int:
	profile = os.environ.get("DOTFILES_PROFILE") or None
	dry_run = dotfiles_dry_run()
	return bootstrap_flow(install_packages=True, link=False, profile=profile, dry_run=dry_run)


if __name__ == "__main__":
	raise SystemExit(main())
