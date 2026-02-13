#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess

from py_venv_create import create_venv, detect_repo_root


def _run(cmd: list[str]) -> int:
	completed = subprocess.run(cmd, check=False)
	return completed.returncode


def _has_executable(path: Path) -> bool:
	return path.exists() and os.access(path, os.X_OK)


def ensure_venv(repo_root: Path, venv_dir: Path) -> int:
	venv_python = venv_dir / "bin" / "python"
	if _has_executable(venv_python):
		return 0

	print("pre-commit: criando virtualenv local em ./venv...")
	py_venv_create = repo_root / "bin" / "py_venv_create.py"
	venv_create = repo_root / "bin" / "venv_create"

	if py_venv_create.exists():
		if create_venv(repo_root=repo_root, venv_dir=venv_dir, recreate=False) != 0:
			print("pre-commit: erro: falha ao executar bin/py_venv_create.py.")
			return 1
	elif _has_executable(venv_create):
		if _run([str(venv_create)]) != 0:
			print("pre-commit: erro: falha ao executar bin/venv_create.")
			return 1
	elif shutil.which("pyenv"):
		if _run(["pyenv", "exec", "python", "-m", "venv", str(venv_dir)]) != 0:
			print("pre-commit: erro: falha ao criar ./venv via pyenv.")
			return 1
	elif shutil.which("python3"):
		if _run(["python3", "-m", "venv", str(venv_dir)]) != 0:
			print("pre-commit: erro: falha ao criar ./venv via python3.")
			return 1
	elif shutil.which("python"):
		if _run(["python", "-m", "venv", str(venv_dir)]) != 0:
			print("pre-commit: erro: falha ao criar ./venv via python.")
			return 1
	else:
		print("pre-commit: erro: python nao encontrado para criar ./venv.")
		return 1

	if not _has_executable(venv_python):
		print("pre-commit: erro: nao foi possivel criar ./venv.")
		return 1
	return 0


def main() -> int:
	repo_root = detect_repo_root()
	venv_dir = repo_root / "venv"
	return ensure_venv(repo_root, venv_dir)


if __name__ == "__main__":
	raise SystemExit(main())
