#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import mouse_battery

if __name__ == "__main__":
	raise SystemExit(mouse_battery(sys.argv[1:]))
