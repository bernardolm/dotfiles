#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import vpn_get_ips


if __name__ == "__main__":
    raise SystemExit(vpn_get_ips(sys.argv[1:]))
