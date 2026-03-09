#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_images_list


if __name__ == "__main__":
    raise SystemExit(docker_images_list(sys.argv[1:]))
