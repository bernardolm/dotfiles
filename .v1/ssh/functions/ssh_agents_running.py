#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_agents_running


if __name__ == "__main__":
    raise SystemExit(ssh_agents_running(sys.argv[1:]))
