#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import hibernate_now

if __name__ == "__main__":
	raise SystemExit(hibernate_now(sys.argv[1:]))
