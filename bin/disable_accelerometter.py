#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import disable_accelerometter

if __name__ == "__main__":
	raise SystemExit(disable_accelerometter(sys.argv[1:]))
