#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import chmod_easy


if __name__ == "__main__":
    raise SystemExit(chmod_easy(sys.argv[1:]))
