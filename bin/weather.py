#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import weather

if __name__ == "__main__":
	raise SystemExit(weather(sys.argv[1:]))
