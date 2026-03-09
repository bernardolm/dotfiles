#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zplug import zplug_reset


if __name__ == "__main__":
    raise SystemExit(zplug_reset(sys.argv[1:]))
