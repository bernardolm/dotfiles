#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import network_reset_iptables


if __name__ == "__main__":
    raise SystemExit(network_reset_iptables(sys.argv[1:]))
