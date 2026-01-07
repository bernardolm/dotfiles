#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import networks_etup_tunnel


if __name__ == "__main__":
    raise SystemExit(networks_etup_tunnel(sys.argv[1:]))
