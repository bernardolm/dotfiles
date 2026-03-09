#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_image_remove


if __name__ == "__main__":
    raise SystemExit(docker_image_remove(sys.argv[1:]))
