#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.duckdns import duckdns_update_host

if __name__ == "__main__":
	raise SystemExit(duckdns_update_host(sys.argv[1:]))
