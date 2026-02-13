#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import color

if __name__ == "__main__":
	raise SystemExit(color(sys.argv[1:]))
