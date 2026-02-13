#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.bootstrap_flow import bootstrap_flow


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main() -> int:
	profile = os.environ.get("DOTFILES_PROFILE") or None
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	return bootstrap_flow(install_packages=True, link=False, profile=profile, dry_run=dry_run)


if __name__ == "__main__":
	raise SystemExit(main())
