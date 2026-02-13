#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import vpn_ip_subnet


if __name__ == "__main__":
    raise SystemExit(vpn_ip_subnet(sys.argv[1:]))
