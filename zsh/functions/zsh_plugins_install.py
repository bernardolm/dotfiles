#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import zsh_plugins_install


if __name__ == "__main__":
    raise SystemExit(zsh_plugins_install(sys.argv[1:]))
