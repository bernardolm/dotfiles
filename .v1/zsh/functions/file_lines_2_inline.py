#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import file_lines_2_inline


if __name__ == "__main__":
    raise SystemExit(file_lines_2_inline(sys.argv[1:]))
