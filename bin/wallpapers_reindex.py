#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import wallpapers_reindex


if __name__ == "__main__":
    raise SystemExit(wallpapers_reindex(sys.argv[1:]))
