#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import emoji_random

if __name__ == "__main__":
	raise SystemExit(emoji_random(sys.argv[1:]))
