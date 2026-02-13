#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import chrome_bookmarks_backup


if __name__ == "__main__":
    raise SystemExit(chrome_bookmarks_backup(sys.argv[1:]))
