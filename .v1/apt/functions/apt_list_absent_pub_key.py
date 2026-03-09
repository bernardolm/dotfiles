#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.apt import apt_list_absent_pub_key


if __name__ == "__main__":
    raise SystemExit(apt_list_absent_pub_key(sys.argv[1:]))
