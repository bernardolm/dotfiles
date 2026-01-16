#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.starship import starship_update_theme


if __name__ == "__main__":
    raise SystemExit(starship_update_theme(sys.argv[1:]))
