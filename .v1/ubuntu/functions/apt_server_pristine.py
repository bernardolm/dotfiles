#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ubuntu import apt_server_pristine


if __name__ == "__main__":
    raise SystemExit(apt_server_pristine(sys.argv[1:]))
