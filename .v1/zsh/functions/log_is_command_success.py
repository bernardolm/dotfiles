#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import log_is_command_success


if __name__ == "__main__":
    raise SystemExit(log_is_command_success(sys.argv[1:]))
