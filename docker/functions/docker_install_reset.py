#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_install_reset


if __name__ == "__main__":
    raise SystemExit(docker_install_reset(sys.argv[1:]))
