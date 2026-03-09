#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import elapsed_time


if __name__ == "__main__":
    raise SystemExit(elapsed_time(sys.argv[1:]))
