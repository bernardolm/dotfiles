#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_commits_ahead


if __name__ == "__main__":
    raise SystemExit(git_commits_ahead(sys.argv[1:]))
