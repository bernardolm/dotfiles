#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import google_drive_sync

if __name__ == "__main__":
	raise SystemExit(google_drive_sync(sys.argv[1:]))
