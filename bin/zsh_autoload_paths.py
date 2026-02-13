#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import zsh_autoload_paths

if __name__ == "__main__":
	raise SystemExit(zsh_autoload_paths(sys.argv[1:]))
