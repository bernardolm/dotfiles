#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import shutil
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bin.common import dotfiles_dry_run
from bootstrap.detect_platform import detect_platform
from bootstrap.run import run


def install_powershell(dry_run: bool = False, platform_name: str | None = None) -> int:
	resolved_platform = (platform_name or detect_platform()).strip().lower()
	if resolved_platform != "windows":
		print("PowerShell install skipped: this repository only installs/configures "
					"PowerShell on Windows.")
		return 0

	if _pwsh_exists():
		print("PowerShell already installed (pwsh found).")
		return 0

	print("Installing PowerShell for platform: windows")
	return _install_windows(dry_run=dry_run)


def _install_windows(dry_run: bool = False) -> int:
	if shutil.which("winget") is None and not dry_run:
		print("error: winget not found; cannot install PowerShell on Windows.")
		return 1
	try:
		run(
			[
				"winget",
				"install",
				"--id",
				"Microsoft.PowerShell",
				"--accept-source-agreements",
				"--accept-package-agreements",
			],
			check=True,
			dry_run=dry_run,
		)
		return _final_check(dry_run=dry_run)
	except Exception as exc:
		print(f"error: failed to install PowerShell via winget: {exc}")
		return 1


def _pwsh_exists() -> bool:
	return shutil.which("pwsh") is not None or shutil.which("pwsh.exe") is not None


def _final_check(dry_run: bool = False) -> int:
	if dry_run:
		return 0
	if _pwsh_exists():
		print("PowerShell installed successfully.")
		return 0
	print("error: installation finished but pwsh was not found in PATH.")
	return 1


def main() -> int:
	platform_name = os.environ.get("DOTFILES_PLATFORM") or None
	dry_run = dotfiles_dry_run()
	return install_powershell(dry_run=dry_run, platform_name=platform_name)


if __name__ == "__main__":
	raise SystemExit(main())
