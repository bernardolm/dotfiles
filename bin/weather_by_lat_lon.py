#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.zsh import weather_by_lat_lon

if __name__ == "__main__":
	raise SystemExit(weather_by_lat_lon(sys.argv[1:]))
