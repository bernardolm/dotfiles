#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import spaceship_histsize

if __name__ == "__main__":
	raise SystemExit(spaceship_histsize(sys.argv[1:]))
