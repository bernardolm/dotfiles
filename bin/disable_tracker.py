#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import disable_tracker


if __name__ == "__main__":
    raise SystemExit(disable_tracker(sys.argv[1:]))
