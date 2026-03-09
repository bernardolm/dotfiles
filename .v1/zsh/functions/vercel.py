#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import vercel


if __name__ == "__main__":
    raise SystemExit(vercel(sys.argv[1:]))
