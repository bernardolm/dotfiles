#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.node import tldr


if __name__ == "__main__":
    raise SystemExit(tldr(sys.argv[1:]))
