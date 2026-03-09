#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import vpn_ip_route_add


if __name__ == "__main__":
    raise SystemExit(vpn_ip_route_add(sys.argv[1:]))
