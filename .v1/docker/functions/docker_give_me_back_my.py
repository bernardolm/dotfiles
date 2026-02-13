#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.docker import docker_give_me_back_my


if __name__ == "__main__":
    raise SystemExit(docker_give_me_back_my(sys.argv[1:]))
