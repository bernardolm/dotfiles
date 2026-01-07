#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import disable_amazon_search


if __name__ == "__main__":
    raise SystemExit(disable_amazon_search(sys.argv[1:]))
