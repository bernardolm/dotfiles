#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import subprocess

from common import repo_root


def _run(cmd: list[str]) -> int:
	completed = subprocess.run(cmd, check=False)
	return completed.returncode


def _has_executable(path: Path) -> bool:
	return path.exists() and os.access(path, os.X_OK)


DEFAULT_TOOLS = ("unimport", "isort", "yapf")


def ensure_tools(venv_dir: Path, requirements_file: Path, tools: list[str]) -> int:
	venv_bin = venv_dir / "bin"
	venv_python = venv_bin / "python"
	if not _has_executable(venv_python):
		print("pre-commit: erro: ./venv nao disponivel.")
		return 1

	if not requirements_file.exists():
		print(f"pre-commit: erro: requirements.txt nao encontrado em {requirements_file}.")
		return 1

	missing = [tool for tool in tools if not _has_executable(venv_bin / tool)]
	if not missing:
		return 0

	print(f"pre-commit: instalando ferramentas Python no venv: {' '.join(missing)}")
	if _run([str(venv_python), "-m", "pip", "install", "--requirement", str(requirements_file)]) != 0:
		print("pre-commit: erro: falha ao instalar requirements no venv.")
		return 1

	for tool in tools:
		if not _has_executable(venv_bin / tool):
			print(f"pre-commit: erro: ferramenta '{tool}' indisponivel apos instalar requirements.txt.")
			return 1
	return 0


def main() -> int:
	root = repo_root(Path(__file__).resolve())
	venv_dir = root / "venv"
	requirements_file = root / "requirements.txt"
	return ensure_tools(venv_dir=venv_dir,
											requirements_file=requirements_file,
											tools=list(DEFAULT_TOOLS))


if __name__ == "__main__":
	raise SystemExit(main())
