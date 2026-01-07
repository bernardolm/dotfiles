#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import log_warn


if __name__ == "__main__":
    raise SystemExit(log_warn(sys.argv[1:]))
