#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_go_to_next_commit


if __name__ == "__main__":
    raise SystemExit(git_go_to_next_commit(sys.argv[1:]))
