#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import dns_local_setup


if __name__ == "__main__":
    raise SystemExit(dns_local_setup(sys.argv[1:]))
