#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_container_pid


if __name__ == "__main__":
    raise SystemExit(docker_container_pid(sys.argv[1:]))
