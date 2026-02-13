#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import files_count

if __name__ == "__main__":
	raise SystemExit(files_count(sys.argv[1:]))
