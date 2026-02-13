#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import extract

if __name__ == "__main__":
	raise SystemExit(extract(sys.argv[1:]))
