#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import memory_used

if __name__ == "__main__":
	raise SystemExit(memory_used(sys.argv[1:]))
