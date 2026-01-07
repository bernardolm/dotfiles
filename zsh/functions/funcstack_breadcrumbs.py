#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import funcstack_breadcrumbs


if __name__ == "__main__":
    raise SystemExit(funcstack_breadcrumbs(sys.argv[1:]))
