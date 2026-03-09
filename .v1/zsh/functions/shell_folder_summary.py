#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import shell_folder_summary


if __name__ == "__main__":
    raise SystemExit(shell_folder_summary(sys.argv[1:]))
