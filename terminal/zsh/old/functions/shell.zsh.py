#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import shell_zsh


if __name__ == "__main__":
    raise SystemExit(shell_zsh(sys.argv[1:]))
