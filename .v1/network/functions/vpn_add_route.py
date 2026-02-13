#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import vpn_add_route


if __name__ == "__main__":
    raise SystemExit(vpn_add_route(sys.argv[1:]))
