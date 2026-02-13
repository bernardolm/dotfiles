#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import contains_in_array

if __name__ == "__main__":
	raise SystemExit(contains_in_array(sys.argv[1:]))
