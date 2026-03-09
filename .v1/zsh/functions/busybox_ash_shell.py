#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import busybox_ash_shell


if __name__ == "__main__":
    raise SystemExit(busybox_ash_shell(sys.argv[1:]))
