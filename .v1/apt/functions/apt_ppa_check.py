#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.apt import apt_ppa_check


if __name__ == "__main__":
    raise SystemExit(apt_ppa_check(sys.argv[1:]))
