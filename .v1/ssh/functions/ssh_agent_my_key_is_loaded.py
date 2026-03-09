#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_agent_my_key_is_loaded


if __name__ == "__main__":
    raise SystemExit(ssh_agent_my_key_is_loaded(sys.argv[1:]))
