#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import slugify


if __name__ == "__main__":
    raise SystemExit(slugify(sys.argv[1:]))
