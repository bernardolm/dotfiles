#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import dot_ls


if __name__ == "__main__":
    raise SystemExit(dot_ls(sys.argv[1:]))
