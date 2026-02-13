#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import jump_last_line

if __name__ == "__main__":
	raise SystemExit(jump_last_line(sys.argv[1:]))
