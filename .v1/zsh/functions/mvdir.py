#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import mvdir


if __name__ == "__main__":
    raise SystemExit(mvdir(sys.argv[1:]))
