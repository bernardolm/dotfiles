#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import spaceship_random_emoji

if __name__ == "__main__":
	raise SystemExit(spaceship_random_emoji(sys.argv[1:]))
