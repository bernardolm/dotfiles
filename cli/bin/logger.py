#!/usr/bin/env python3
from __future__ import annotations

from datetime import datetime
import os
from pathlib import Path
import random
import re
import sys
import time
from typing import Callable

from common import is_truthy
from elapsed_time import elapsed_delete, elapsed_path, elapsed_read, elapsed_set, elapsed_value


_COLORS: dict[str, str] = {
	"no": "\033[0m",
	"black": "\033[0;30m",
	"red": "\033[0;31m",
	"green": "\033[0;32m",
	"brown": "\033[0;33m",
	"blue": "\033[0;34m",
	"purple": "\033[0;35m",
	"cyan": "\033[0;36m",
	"light_gray": "\033[0;37m",
	"gray": "\033[1;30m",
	"rose": "\033[1;31m",
	"light_green": "\033[1;32m",
	"yellow": "\033[1;33m",
	"light_blue": "\033[1;34m",
	"light_purple": "\033[1;35m",
	"light_cyan": "\033[1;36m",
	"white": "\033[1;37m",
	"bg_purple": "\033[38;5;15m\033[48;5;129m\033[1m ",
	"bg_blue": "\033[38;5;15m\033[48;5;21m\033[1m ",
	"bg_cyan": "\033[38;5;235m\033[48;5;51m\033[1m ",
	"bg_green": "\033[38;5;235m\033[48;5;40m\033[1m ",
	"bg_grey": "\033[38;5;235m\033[48;5;253m\033[1m ",
	"bg_red": "\033[38;5;235m\033[48;5;9m\033[1m ",
	"bg_rose": "\033[38;5;15m\033[48;5;201m\033[1m ",
	"bg_white": "\033[38;5;235m\033[48;5;5m\033[1m ",
	"bg_yellow": "\033[38;5;235m\033[48;5;226m\033[1m ",
}


def color(name: str) -> str:
	if name.startswith("x") and name[1:].isdigit():
		return f"\033[38;5;{name[1:]}m"
	return _COLORS.get(name, "")


def _join(argv: list[str]) -> str:
	return " ".join(str(item) for item in argv if item is not None).strip()


def _debug_enabled() -> bool:
	return is_truthy(os.environ.get("SHELL_DEBUG"))


def _trace_enabled() -> bool:
	return is_truthy(os.environ.get("SHELL_TRACE"))


def _trace_hint() -> str:
	if not _trace_enabled():
		return ""
	try:
		frame = sys._getframe(3)  # noqa: SLF001
	except ValueError:
		return ""
	return f" ({Path(frame.f_code.co_filename).name}:{frame.f_lineno})"


def log_echo(argv: list[str], stream: object | None = None) -> int:
	message = _join(argv)
	if not message:
		return 0
	target = sys.stdout if stream is None else stream
	print(f"{message}{_trace_hint()}", file=target)
	return 0


def _styled_message(icon: str, tone: str, argv: list[str]) -> str:
	return f"{icon} {color(tone)}{_join(argv)} {color('no')}"


def log_debug(argv: list[str]) -> int:
	return log_echo([_styled_message("🐞", "bg_grey", argv)])


def log_info(argv: list[str]) -> int:
	return log_echo([_styled_message("💬", "bg_cyan", argv)])


def log_warn(argv: list[str]) -> int:
	return log_echo([_styled_message("🚧", "bg_yellow", argv)])


def log_error(argv: list[str]) -> int:
	return log_echo([_styled_message("💣", "bg_red", argv)], stream=sys.stderr)


def log_env(argv: list[str]) -> int:
	if not argv:
		return 0
	pattern = re.compile(f"^{argv[0]}=.*")
	for key, value in os.environ.items():
		line = f"{key}={value}"
		if pattern.search(line):
			return log_echo([f"{color('bg_grey')}{line} {color('no')}"])
	return 0


def log_is_command_success(argv: list[str]) -> int:
	status = 0
	if argv:
		try:
			status = int(argv[0])
		except ValueError:
			status = 1
	if status == 0:
		print(f"{color('bg_green')}➿ 😉{color('no')}")
	else:
		print(f"{color('bg_red')}➿ 🤬{color('no')}")
	return 0


def log_start(argv: list[str]) -> int:
	elapsed_set(argv)
	if _debug_enabled():
		log_echo([f"🚥 starting {_join(argv)}"])
	return 0


def log_finish(argv: list[str]) -> int:
	start_ms = elapsed_read(argv)

	message = _join(argv)
	prefix = f"🚥 {message} {color('light_cyan')}was finished{color('no')} "
	suffix = ""

	if start_ms is not None:
		elapsed = elapsed_value(start_ms)
		if elapsed:
			suffix = f"⏱️  took {elapsed}"
	else:
		now = datetime.now()
		suffix = f"⌚ at {color('yellow')}{now:%H:%M} {color('gray')}{now:%S.%f}{color('no')} "

	elapsed_delete(argv)

	if suffix:
		return log_echo([f"{prefix}{suffix}"])
	return 0


def _emoji_random(argv: list[str]) -> str:
	items = argv if argv else ["🦥", "😴", "💤", "🥱"]
	return random.choice(items)


def log_waiting(argv: list[str]) -> int:
	remaining = 10
	while True:
		time.sleep(7)
		path = elapsed_path(argv)
		if not path.exists():
			break
		remaining -= 1
		if remaining <= 0:
			break
		log_echo([
			f"{_join(argv)} {color('gray')}is taking too long to load{color('no')} {_emoji_random([])}",
		])
	return 0


def log(argv: list[str]) -> int:
	if not argv:
		return 0
	level = argv[0].strip().lower()
	payload = argv[1:]

	if level in {"debug", "env"} and not _debug_enabled():
		return 0

	dispatch: dict[str, Callable[[list[str]], int]] = {
		"debug": log_debug,
		"echo": log_echo,
		"env": log_env,
		"error": log_error,
		"finish": log_finish,
		"info": log_info,
		"is_command_success": log_is_command_success,
		"start": log_start,
		"waiting": log_waiting,
		"warn": log_warn,
	}
	handler = dispatch.get(level)
	if handler is None:
		return log_echo([_join(argv)])
	return handler(payload)


def main(argv: list[str] | None = None) -> int:
	args = list(sys.argv[1:] if argv is None else argv)
	if not args:
		return 0

	if args[0] == "log":
		return log(args[1:])
	return log(args)


if __name__ == "__main__":
	raise SystemExit(main())
