#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import php

if __name__ == "__main__":
	raise SystemExit(php(sys.argv[1:]))
