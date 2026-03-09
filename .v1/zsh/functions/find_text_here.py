#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import find_text_here


if __name__ == "__main__":
    raise SystemExit(find_text_here(sys.argv[1:]))
