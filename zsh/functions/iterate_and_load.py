#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import iterate_and_load


if __name__ == "__main__":
    raise SystemExit(iterate_and_load(sys.argv[1:]))
