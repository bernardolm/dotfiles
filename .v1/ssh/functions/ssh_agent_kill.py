#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_agent_kill


if __name__ == "__main__":
    raise SystemExit(ssh_agent_kill(sys.argv[1:]))
