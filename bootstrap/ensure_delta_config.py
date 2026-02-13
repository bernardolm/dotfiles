#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bootstrap.ensure_symlink import ensure_symlink
from bootstrap.repo_root import repo_root


def ensure_delta_config(platform_name: str, dry_run: bool = False) -> None:
	root = repo_root()
	delta_src = root / "terminal/git/gitconfig.delta"
	delta_dest = Path.home() / ".config/git/delta.conf"

	if platform_name in {"darwin", "wsl", "ubuntu", "linux", "alpine"}:
		if not delta_src.exists():
			print(f"warning: delta source not found, skipping: {delta_src}")
			return
		ensure_symlink(delta_src, delta_dest, dry_run=dry_run)
		return

	if delta_dest.exists() and not dry_run:
		delta_dest.unlink()


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main() -> int:
	platform_name = (os.environ.get("DOTFILES_PLATFORM") or "").strip().lower()
	if not platform_name:
		print("warning: DOTFILES_PLATFORM nao definido; ensure_delta_config ignorado.")
		return 0
	dry_run = _is_truthy(os.environ.get("DOTFILES_DRY_RUN", "0"))
	ensure_delta_config(platform_name, dry_run=dry_run)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
