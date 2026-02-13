#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import conky_start

if __name__ == "__main__":
	raise SystemExit(conky_start(sys.argv[1:]))
