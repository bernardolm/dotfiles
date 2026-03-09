#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import which_shell


if __name__ == "__main__":
    raise SystemExit(which_shell(sys.argv[1:]))
