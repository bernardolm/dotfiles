#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import ip_host_over_wsl_nat


if __name__ == "__main__":
    raise SystemExit(ip_host_over_wsl_nat(sys.argv[1:]))
