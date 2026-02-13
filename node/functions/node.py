#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.node import node


if __name__ == "__main__":
    raise SystemExit(node(sys.argv[1:]))
