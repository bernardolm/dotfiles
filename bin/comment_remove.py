#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import comment_remove

if __name__ == "__main__":
	raise SystemExit(comment_remove(sys.argv[1:]))
