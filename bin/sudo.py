#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import sudo


if __name__ == "__main__":
    raise SystemExit(sudo(sys.argv[1:]))
