#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import db_migrate

if __name__ == "__main__":
	raise SystemExit(db_migrate(sys.argv[1:]))
