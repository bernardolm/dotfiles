#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ssh import ssh_fs_dpipe


if __name__ == "__main__":
    raise SystemExit(ssh_fs_dpipe(sys.argv[1:]))
