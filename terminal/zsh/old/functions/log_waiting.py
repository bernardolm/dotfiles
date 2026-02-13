#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import log_waiting

if __name__ == "__main__":
	raise SystemExit(log_waiting(sys.argv[1:]))
