#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_exec_interative


if __name__ == "__main__":
    raise SystemExit(docker_exec_interative(sys.argv[1:]))
