#!/usr/bin/env python3
from datetime import datetime
import time

if __name__ == "__main__":
	now = datetime.now()
	nanos = time.time_ns() % 1_000_000_000
	print(now.strftime("%Y-%m-%d_%H-%M-%S_") + f"{nanos:09d}")
