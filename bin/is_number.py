#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import is_number

if __name__ == "__main__":
	raise SystemExit(is_number(sys.argv[1:]))
