#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import figlet_maker

if __name__ == "__main__":
	raise SystemExit(figlet_maker(sys.argv[1:]))
