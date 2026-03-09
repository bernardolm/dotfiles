#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_workspaces_restore


if __name__ == "__main__":
    raise SystemExit(git_workspaces_restore(sys.argv[1:]))
