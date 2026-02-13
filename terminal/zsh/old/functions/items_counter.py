#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import items_counter

if __name__ == "__main__":
	raise SystemExit(items_counter(sys.argv[1:]))
