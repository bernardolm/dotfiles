#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import plugins_list

if __name__ == "__main__":
	raise SystemExit(plugins_list(sys.argv[1:]))
