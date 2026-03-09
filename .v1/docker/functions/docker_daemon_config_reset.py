#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_daemon_config_reset


if __name__ == "__main__":
    raise SystemExit(docker_daemon_config_reset(sys.argv[1:]))
