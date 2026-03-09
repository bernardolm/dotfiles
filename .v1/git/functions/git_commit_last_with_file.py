#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_commit_last_with_file


if __name__ == "__main__":
    raise SystemExit(git_commit_last_with_file(sys.argv[1:]))
