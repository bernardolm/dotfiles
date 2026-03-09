#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ubuntu import snap_clean


if __name__ == "__main__":
    raise SystemExit(snap_clean(sys.argv[1:]))
