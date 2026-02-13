#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import memory_used_watcher

if __name__ == "__main__":
	raise SystemExit(memory_used_watcher(sys.argv[1:]))
