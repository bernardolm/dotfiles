from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
	sys.path.insert(0, str(ROOT))

from bin.platform import platform


__all__ = ["default_code_cli_locations"]


def default_code_cli_locations() -> list[Path]:
	os_name = platform()
	locations: list[Path] = []

	if os_name == "windows":
		env_paths = [
			os.environ.get("LOCALAPPDATA"),
			os.environ.get("PROGRAMFILES"),
			os.environ.get("PROGRAMFILES(X86)"),
		]
		suffixes = [
			Path("Programs/Microsoft VS Code/bin/code.cmd"),
			Path("Programs/Microsoft VS Code Insiders/bin/code-insiders.cmd"),
			Path("VSCodium/bin/codium.cmd"),
			Path("Microsoft VS Code/bin/code.cmd"),
			Path("Microsoft VS Code Insiders/bin/code-insiders.cmd"),
		]
		for base in env_paths:
			if not base:
				continue
			base_path = Path(base)
			for suffix in suffixes:
				locations.append(base_path / suffix)
		return locations

	if os_name == "darwin":
		locations.extend([
			Path("/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"),
			Path(
				"/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"),
			Path("/Applications/VSCodium.app/Contents/Resources/app/bin/codium"),
			Path.home() / "Applications/Visual Studio Code.app/Contents/Resources/app/bin/code",
			Path.home() /
			"Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders",
			Path.home() / "Applications/VSCodium.app/Contents/Resources/app/bin/codium",
		])
		return locations

	locations.extend([
		Path("/usr/bin/code"),
		Path("/usr/bin/code-insiders"),
		Path("/usr/bin/codium"),
		Path("/snap/bin/code"),
		Path("/snap/bin/code-insiders"),
		Path("/snap/bin/codium"),
	])
	return locations
