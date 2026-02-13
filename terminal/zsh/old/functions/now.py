#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import now

if __name__ == "__main__":
	raise SystemExit(now(sys.argv[1:]))
