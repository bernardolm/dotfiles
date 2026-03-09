#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import caller_function


if __name__ == "__main__":
    raise SystemExit(caller_function(sys.argv[1:]))
