#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_checkout_pristine


if __name__ == "__main__":
    raise SystemExit(git_checkout_pristine(sys.argv[1:]))
