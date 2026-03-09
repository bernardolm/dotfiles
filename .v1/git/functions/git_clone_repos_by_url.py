#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_clone_repos_by_url


if __name__ == "__main__":
    raise SystemExit(git_clone_repos_by_url(sys.argv[1:]))
