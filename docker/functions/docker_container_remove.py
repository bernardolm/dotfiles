#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_container_remove


if __name__ == "__main__":
    raise SystemExit(docker_container_remove(sys.argv[1:]))
