#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import subprocess

from common import repo_root


def _run(cmd: list[str], check: bool = True) -> int:
	completed = subprocess.run(cmd, check=False)
	if check and completed.returncode != 0:
		return completed.returncode
	return completed.returncode


def _staged_python_files(root: Path) -> list[str]:
	completed = subprocess.run(
		["git", "-C", str(root), "diff", "--cached", "--name-only", "--diff-filter=ACMR"],
		check=False,
		capture_output=True,
		text=True,
	)
	if completed.returncode != 0:
		return []
	files: list[str] = []
	for line in completed.stdout.splitlines():
		item = line.strip()
		if item.endswith(".py"):
			files.append(item)
	return files


def main() -> int:
	root = repo_root(Path(__file__).resolve())
	venv_bin = root / "venv" / "bin"
	isort_settings_path = root / "pyproject.toml"
	staged_python_files = _staged_python_files(root)
	if not staged_python_files:
		return 0

	unimport_cmd = [str(venv_bin / "unimport"), *staged_python_files]
	if _run(unimport_cmd, check=False) == 0:
		print("pre-commit: unimport aplicado.")
	else:
		print("pre-commit: aviso: unimport retornou erro; seguindo com isort/yapf.")

	isort_cmd = [
		str(venv_bin / "isort"),
		"--settings-path",
		str(isort_settings_path),
		*staged_python_files,
	]
	if _run(isort_cmd, check=True) != 0:
		print("pre-commit: erro: isort falhou.")
		return 1
	print("pre-commit: isort aplicado.")

	yapf_cmd = [str(venv_bin / "yapf"), "--in-place", *staged_python_files]
	if _run(yapf_cmd, check=True) != 0:
		print("pre-commit: erro: yapf falhou.")
		return 1
	print("pre-commit: yapf aplicado.")

	return 0


if __name__ == "__main__":
	raise SystemExit(main())
