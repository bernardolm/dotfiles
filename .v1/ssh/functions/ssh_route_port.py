#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_route_port


if __name__ == "__main__":
    raise SystemExit(ssh_route_port(sys.argv[1:]))
