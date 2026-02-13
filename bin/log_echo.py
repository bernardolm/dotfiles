#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import log_echo

if __name__ == "__main__":
	raise SystemExit(log_echo(sys.argv[1:]))
