#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.starship import starship_update_nerd_font


if __name__ == "__main__":
    raise SystemExit(starship_update_nerd_font(sys.argv[1:]))
