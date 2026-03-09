#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_current_commit


if __name__ == "__main__":
    raise SystemExit(git_current_commit(sys.argv[1:]))
