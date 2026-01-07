#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_agent_state


if __name__ == "__main__":
    raise SystemExit(ssh_agent_state(sys.argv[1:]))
