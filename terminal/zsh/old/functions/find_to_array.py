#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import find_to_array

if __name__ == "__main__":
	raise SystemExit(find_to_array(sys.argv[1:]))
