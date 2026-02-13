#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path


def repo_root() -> Path:
	return Path.home() / "dotfiles"


if __name__ == "__main__":
	print(repo_root())
