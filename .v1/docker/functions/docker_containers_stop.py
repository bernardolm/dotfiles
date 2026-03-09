#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_containers_stop


if __name__ == "__main__":
    raise SystemExit(docker_containers_stop(sys.argv[1:]))
