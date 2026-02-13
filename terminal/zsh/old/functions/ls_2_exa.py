#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import ls_2_exa

if __name__ == "__main__":
	raise SystemExit(ls_2_exa(sys.argv[1:]))
