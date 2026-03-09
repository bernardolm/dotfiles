#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import re
import sys
import time
from typing import Sequence


_COLORS: dict[str, str] = {
	"no": "\033[0m",
	"purple": "\033[0;35m",
	"light_purple": "\033[1;35m",
	"light_blue": "\033[1;34m",
	"blue": "\033[0;34m",
	"cyan": "\033[0;36m",
	"light_cyan": "\033[1;36m",
	"light_green": "\033[1;32m",
	"green": "\033[0;32m",
}


def color(name: str) -> str:
	return _COLORS.get(name, "")


def now_ms() -> int:
	return int(time.time() * 1000)


def slugify_text(text: str) -> str:
	value = text.strip().lower()
	value = re.sub(r"[^a-z0-9]+", "-", value)
	return value.strip("-") or "default"


def elapsed_key(argv: Sequence[str]) -> str:
	return slugify_text(" ".join(str(item) for item in argv if item is not None))


def elapsed_root() -> Path:
	root = os.environ.get("ELAPSED_TIME_ROOT", "").strip()
	if root:
		path = Path(root).expanduser()
		path.mkdir(parents=True, exist_ok=True)
		return path
	tmp_user = os.environ.get("TMP_USER", str(Path.home() / "sync/tmp/unknown"))
	session_id = os.environ.get("SESSION_ID", "default")
	path = Path(tmp_user) / "elapsed_time" / session_id
	path.mkdir(parents=True, exist_ok=True)
	return path


def elapsed_path(argv: Sequence[str]) -> Path:
	return elapsed_root() / elapsed_key(argv)


def elapsed_set(argv: Sequence[str]) -> int:
	path = elapsed_path(argv)
	path.parent.mkdir(parents=True, exist_ok=True)
	value = now_ms()
	path.write_text(str(value), encoding="utf-8")
	return value


def elapsed_read(argv: Sequence[str]) -> int | None:
	path = elapsed_path(argv)
	if path.is_dir() or not path.is_file():
		return None
	try:
		return int(path.read_text(encoding="utf-8").strip())
	except ValueError:
		return None


def elapsed_delete(argv: Sequence[str]) -> None:
	path = elapsed_path(argv)
	try:
		path.unlink(missing_ok=True)
	except OSError:
		pass


def elapsed_value(start_ms: int) -> str:
	d_ms = now_ms() - start_ms
	if d_ms <= 500:
		return ""
	d_s = d_ms // 1000
	ms = d_ms % 1000
	s = d_s % 60
	m = (d_s // 60) % 60
	h = d_s // 3600

	if h > 0:
		return f"{color('purple')}{h}h {m}m {s}s {ms}ms{color('no')} 🪦"
	if m > 0:
		return f"{color('light_purple')}{m}m {s}s {ms}ms{color('no')} 🥶"
	if s >= 3:
		return f"{color('light_blue')}{s}s {ms}ms{color('no')} 🐢"
	if ms >= 2500:
		return f"{color('blue')}{s}s {ms}ms{color('no')} 🤔"
	if s > 0:
		return f"{color('cyan')}{s}s {ms}ms{color('no')} 🛺"
	if ms > 500:
		return f"{color('light_cyan')}{ms}ms{color('no')} 🚗"
	if ms > 100:
		return f"{color('light_green')}{ms}ms{color('no')} 🚁"
	return f"{color('green')}{ms}ms{color('no')} 🚀"


def elapsed_status_text() -> str:
	root = elapsed_root()
	rows: list[tuple[str, str]] = []
	for path in sorted(root.glob("*")):
		if path.is_dir():
			continue
		key = path.name
		value = path.read_text(encoding="utf-8", errors="ignore").strip()
		rows.append((key, value))

	key_size = max([len("key"), *[len(key) for key, _ in rows]])
	value_size = max([len("value"), *[len(value) for _, value in rows]])
	sep = "\t"

	lines = [
		f"{'key':<{key_size}}{sep}{'value':<{value_size}}",
		f"{'-' * key_size}{sep}{'-' * value_size}",
	]
	for key, value in rows:
		lines.append(f"{key:<{key_size}}{sep}{value:<{value_size}}")
	return "\n".join(lines)


def _cli_set(args: list[str]) -> int:
	elapsed_set(args)
	return 0


def _cli_get(args: list[str]) -> int:
	value = elapsed_read(args)
	if value is not None:
		print(value)
	return 0


def _cli_del(args: list[str]) -> int:
	elapsed_delete(args)
	return 0


def _cli_status(args: list[str]) -> int:
	print(elapsed_status_text())
	return 0


def _cli_value(args: list[str]) -> int:
	if not args:
		return 0
	try:
		start_ms = int(args[0])
	except ValueError:
		return 1
	value = elapsed_value(start_ms)
	if value:
		print(value)
	return 0


def main(argv: list[str] | None = None) -> int:
	args = list(sys.argv[1:] if argv is None else argv)
	if not args:
		return 0

	commands = {
		"set": _cli_set,
		"get": _cli_get,
		"del": _cli_del,
		"status": _cli_status,
		"value": _cli_value,
	}

	command = args[0].strip().lower()
	handler = commands.get(command)
	if handler is not None:
		return handler(args[1:])

	# Compat: `elapsed_time.py <start_ms>` behaves like old `elapsed_time`.
	return _cli_value(args)


if __name__ == "__main__":
	raise SystemExit(main())
