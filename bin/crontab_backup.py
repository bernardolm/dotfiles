#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import crontab_backup

if __name__ == "__main__":
	raise SystemExit(crontab_backup(sys.argv[1:]))
