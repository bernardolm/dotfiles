#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import zsh_plugins_load


if __name__ == "__main__":
    raise SystemExit(zsh_plugins_load(sys.argv[1:]))
