#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path


def repo_root() -> Path:
    env_root = os.environ.get("DOTFILES")
    if env_root:
        root = Path(env_root).expanduser()
        if root.exists():
            return root
    default_root = Path.home() / ".dotfiles"
    if default_root.exists():
        return default_root
    return Path(__file__).resolve().parents[1]


if __name__ == "__main__":
    print(repo_root())
