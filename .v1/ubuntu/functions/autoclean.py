#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ubuntu import autoclean


if __name__ == "__main__":
    raise SystemExit(autoclean(sys.argv[1:]))
