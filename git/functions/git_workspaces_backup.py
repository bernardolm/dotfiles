#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_workspaces_backup


if __name__ == "__main__":
    raise SystemExit(git_workspaces_backup(sys.argv[1:]))
