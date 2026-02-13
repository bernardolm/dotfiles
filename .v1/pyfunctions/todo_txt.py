from __future__ import annotations

import os
import re
import sys

from pyfunctions.common import run


def _read_stdin() -> list[str]:
	return sys.stdin.read().splitlines()


def _write_lines(lines: list[str]) -> None:
	if lines:
	print("\n".join(lines))


def todotxt_hide_create_date(argv: list[str]) -> int:
	lines = _read_stdin()
	cleaned = [re.sub(r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s?", "", line) for line in lines]
	_write_lines(cleaned)
	return 0


def todotxt_hide_footer(argv: list[str]) -> int:
	lines = _read_stdin()
	cleaned = [line for line in lines if not re.match(r"^(--|TODO:)", line)]
	_write_lines(cleaned)
	return 0


def todotxt_hide_project_and_context_symbols(argv: list[str]) -> int:
	lines = _read_stdin()
	cleaned = [re.sub(r"[@+](\w)", r"\1", line) for line in lines]
	_write_lines(cleaned)
	return 0


def todotxt_hide_projects(argv: list[str]) -> int:
	lines = _read_stdin()
	cleaned = [re.sub(r"@[A-Za-z0-9_]", "", line) for line in lines]
	_write_lines(cleaned)
	return 0


def todotxt_highlight_project_and_context(argv: list[str]) -> int:
	lines = _read_stdin()
	cleaned = [re.sub(r"[@+](\w)", "\U0001F3F7 \1", line) for line in lines]
	_write_lines(cleaned)
	return 0


def todo_conky(argv: list[str]) -> int:
	todo_dir = os.environ.get("TODO_DIR", "")
	result = run(["todo.sh", "-d", f"{todo_dir}/conky.cfg", "-@", "-c", "-P", *argv], capture=True)
	text = result.stdout
	lines = text.splitlines()
	lines = [line for line in lines if not re.match(r"^(--|TODO:)", line)]
	lines = [re.sub(r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s?", "", line) for line in lines]
	lines = [re.sub(r"[@+](\w)", r"\1", line) for line in lines]
	_write_lines(lines)
	return 0


def todo_zsh(argv: list[str]) -> int:
	todo_dir = os.environ.get("TODO_DIR", "")
	result = run(["todo.sh", "-d", f"{todo_dir}/zsh.cfg", "-c", "-P", *argv], capture=True)
	text = result.stdout
	lines = text.splitlines()
	lines = [re.sub(r"[0-9]{4}-[0-9]{2}-[0-9]{2}\s?", "", line) for line in lines]
	lines = [re.sub(r"[@+](\w)", "\U0001F3F7 \1", line) for line in lines]
	lines = [re.sub(r"[@+](\w)", r"\1", line) for line in lines]
	_write_lines(lines)
	return 0
