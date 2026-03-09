#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import kill_by_port


if __name__ == "__main__":
    raise SystemExit(kill_by_port(sys.argv[1:]))
