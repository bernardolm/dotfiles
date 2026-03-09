#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import epoch


if __name__ == "__main__":
    raise SystemExit(epoch(sys.argv[1:]))
