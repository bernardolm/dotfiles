#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.duckdns import duckdns_update

if __name__ == "__main__":
	raise SystemExit(duckdns_update(sys.argv[1:]))
