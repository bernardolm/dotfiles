#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_images_sanitize


if __name__ == "__main__":
    raise SystemExit(docker_images_sanitize(sys.argv[1:]))
