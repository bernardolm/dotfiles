#!/usr/bin/env python3
from __future__ import annotations

import sys

from pyfunctions.ubuntu import audio_reset


if __name__ == "__main__":
    raise SystemExit(audio_reset(sys.argv[1:]))
