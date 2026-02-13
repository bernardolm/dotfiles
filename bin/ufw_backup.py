#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ufw import ufw_backup

if __name__ == "__main__":
	raise SystemExit(ufw_backup(sys.argv[1:]))
