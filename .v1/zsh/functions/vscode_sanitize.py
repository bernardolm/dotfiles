#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import vscode_sanitize


if __name__ == "__main__":
    raise SystemExit(vscode_sanitize(sys.argv[1:]))
