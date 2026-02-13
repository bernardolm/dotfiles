#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path


def repo_root() -> Path:
	env_root = os.environ.get("DOTFILES", "").strip()
	if env_root:
		candidate = Path(env_root).expanduser()
		if candidate.exists():
			return candidate

	return Path(__file__).resolve().parents[1]


if __name__ == "__main__":
	print(repo_root())
