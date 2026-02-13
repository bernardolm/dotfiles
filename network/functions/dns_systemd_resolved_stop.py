#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.network import dns_systemd_resolved_stop


if __name__ == "__main__":
    raise SystemExit(dns_systemd_resolved_stop(sys.argv[1:]))
