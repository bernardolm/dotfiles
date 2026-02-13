#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path

from common import repo_root
from py_deps_ensure import DEFAULT_TOOLS, ensure_tools
from py_venv_ensure import ensure_venv


def main() -> int:
	root = repo_root(Path(__file__).resolve())
	venv_dir = root / "venv"
	requirements_file = root / "requirements.txt"

	if ensure_venv(repo_root=root, venv_dir=venv_dir) != 0:
		print("pre-commit: erro: falha ao garantir ./venv via bin/py_venv_ensure.py.")
		return 1
	if ensure_tools(
		venv_dir=venv_dir,
		requirements_file=requirements_file,
		tools=list(DEFAULT_TOOLS),
	) != 0:
		print("pre-commit: erro: falha ao garantir ferramentas via bin/py_deps_ensure.py.")
		return 1
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
