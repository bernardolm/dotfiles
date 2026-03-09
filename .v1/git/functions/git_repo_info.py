#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_repo_info


if __name__ == "__main__":
    raise SystemExit(git_repo_info(sys.argv[1:]))
