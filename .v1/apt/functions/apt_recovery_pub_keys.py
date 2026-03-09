#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.apt import apt_recovery_pub_keys


if __name__ == "__main__":
    raise SystemExit(apt_recovery_pub_keys(sys.argv[1:]))
