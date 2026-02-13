#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import dropbox_sync

if __name__ == "__main__":
	raise SystemExit(dropbox_sync(sys.argv[1:]))
