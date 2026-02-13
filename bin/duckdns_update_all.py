#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.duckdns import duckdns_update_all

if __name__ == "__main__":
	raise SystemExit(duckdns_update_all(sys.argv[1:]))
