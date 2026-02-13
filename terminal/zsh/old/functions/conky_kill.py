#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import conky_kill

if __name__ == "__main__":
	raise SystemExit(conky_kill(sys.argv[1:]))
