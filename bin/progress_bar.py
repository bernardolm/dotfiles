#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import progress_bar

if __name__ == "__main__":
	raise SystemExit(progress_bar(sys.argv[1:]))
