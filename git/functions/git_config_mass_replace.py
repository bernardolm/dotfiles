#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.git import git_config_mass_replace


if __name__ == "__main__":
    raise SystemExit(git_config_mass_replace(sys.argv[1:]))
