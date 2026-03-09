#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_envs


if __name__ == "__main__":
    raise SystemExit(ssh_envs(sys.argv[1:]))
