from __future__ import annotations

import os
from pathlib import Path

from pyfunctions.common import run
from pyfunctions.zsh import log_finish, log_start


def zplug_reset(argv: list[str]) -> int:
	log_start(["zplug: reset"])
	run(["zplug", "clean"], check=False)
	run(["zplug", "clear"], check=False)
	run(["/bin/rm", "-rf", str(Path.home() / ".zplug"), str(Path.home() / ".cache/zplug")], check=False)
	os.environ["ZPLUG_LOG_LOAD_SUCCESS"] = "true"
	os.environ["ZPLUG_LOG_LOAD_FAILURE"] = "true"
	os.environ["ZPLUG_VERBOSE"] = "--verbose"
	log_finish(["zplug: reset"])
	return 0
