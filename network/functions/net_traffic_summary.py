#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import net_traffic_summary


if __name__ == "__main__":
    raise SystemExit(net_traffic_summary(sys.argv[1:]))
