#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import file_size

if __name__ == "__main__":
	raise SystemExit(file_size(sys.argv[1:]))
