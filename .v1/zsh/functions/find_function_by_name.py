#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import find_function_by_name


if __name__ == "__main__":
    raise SystemExit(find_function_by_name(sys.argv[1:]))
