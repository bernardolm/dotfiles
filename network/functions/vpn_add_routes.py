#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import vpn_add_routes


if __name__ == "__main__":
    raise SystemExit(vpn_add_routes(sys.argv[1:]))
