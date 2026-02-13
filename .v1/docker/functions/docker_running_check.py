#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_running_check


if __name__ == "__main__":
    raise SystemExit(docker_running_check(sys.argv[1:]))
