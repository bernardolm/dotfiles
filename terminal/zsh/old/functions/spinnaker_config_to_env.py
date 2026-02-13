#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import spinnaker_config_to_env

if __name__ == "__main__":
	raise SystemExit(spinnaker_config_to_env(sys.argv[1:]))
