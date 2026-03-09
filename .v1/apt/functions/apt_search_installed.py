#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.apt import apt_search_installed


if __name__ == "__main__":
    raise SystemExit(apt_search_installed(sys.argv[1:]))
