#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re
import subprocess
import sys


_LEADING_WHITESPACE_RE = re.compile(r"^([ \t]+)")
_INDENTED_CONTENT_RE = re.compile(r"^[ \t]+[^ \t\r\n]")

_SUPPORTED_SUFFIXES = {
	".py",
	".sh",
	".zsh",
	".bash",
	".ksh",
	".lua",
	".go",
	".js",
	".jsx",
	".ts",
	".tsx",
	".json",
	".jsonc",
	".toml",
	".ini",
	".cfg",
	".conf",
	".css",
	".scss",
	".sass",
	".less",
	".html",
	".xml",
	".sql",
	".tf",
	".tfvars",
	".md",
	".txt",
	".rst",
	".env",
	".gitignore",
	".dockerignore",
	".editorconfig",
	".mk",
}


def _gcd(left: int, right: int) -> int:
	while right != 0:
		left, right = right, left % right
	return left


def _supports_tab_indentation(path: Path) -> bool:
	name = path.name
	if name.endswith(".yml") or name.endswith(".yaml"):
		return False
	if name in {"Dockerfile", "Makefile"}:
		return True
	if name.startswith("Dockerfile.") or name.startswith("Makefile."):
		return True
	return any(name.endswith(suffix) for suffix in _SUPPORTED_SUFFIXES)


def _detect_unit(lines: list[str]) -> int:
	counts: set[int] = set()
	for line in lines:
		if _INDENTED_CONTENT_RE.match(line) is None:
			continue
		match = _LEADING_WHITESPACE_RE.match(line)
		if match is None:
			continue
		prefix = match.group(1)
		space_count = prefix.count(" ")
		if space_count > 0:
			counts.add(space_count)

	if 2 in counts:
		return 2
	if 4 in counts:
		return 4

	group = 0
	for count in counts:
		if count <= 1:
			continue
		if group == 0:
			group = count
			continue
		group = _gcd(group, count)

	if group >= 4 and group % 4 == 0:
		return 4
	return 2


def _normalize_line(line: str, unit: int) -> str:
	match = _LEADING_WHITESPACE_RE.match(line)
	if match is None:
		return line
	prefix = match.group(1)
	tab_count = prefix.count("\t")
	space_count = prefix.count(" ")
	extra_tabs = (space_count + unit - 1) // unit if space_count > 0 else 0
	return ("\t" * (tab_count + extra_tabs)) + line[len(prefix):]


def _normalize_file(path: Path) -> bool:
	try:
		original = path.read_text(encoding="utf-8", errors="ignore")
	except OSError:
		return False

	lines = original.splitlines(keepends=True)
	unit = _detect_unit(lines)
	normalized = "".join(_normalize_line(line, unit) for line in lines)
	if normalized == original:
		return False

	try:
		path.write_text(normalized, encoding="utf-8")
	except OSError:
		return False
	return True


def _staged_files() -> list[str]:
	completed = subprocess.run(
		["git", "diff", "--cached", "--name-only", "--diff-filter=ACMR"],
		check=False,
		capture_output=True,
		text=True,
	)
	if completed.returncode != 0:
		return []
	return [line.strip() for line in completed.stdout.splitlines() if line.strip()]


def run(paths: list[str] | None = None) -> int:
	paths = paths if paths is not None else _staged_files()
	for raw_path in paths:
		path = Path(raw_path)
		if not path.is_file():
			continue
		if not _supports_tab_indentation(path):
			continue
		if _normalize_file(path):
			print(raw_path)
	return 0


if __name__ == "__main__":
	raise SystemExit(run())
