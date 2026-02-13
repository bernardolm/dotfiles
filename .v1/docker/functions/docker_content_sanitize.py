#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_content_sanitize


if __name__ == "__main__":
    raise SystemExit(docker_content_sanitize(sys.argv[1:]))
