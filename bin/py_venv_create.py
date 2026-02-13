#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys


def detect_repo_root() -> Path:
	try:
		result = subprocess.run(
			["git", "rev-parse", "--show-toplevel"],
			capture_output=True,
			text=True,
			check=False,
		)
		if result.returncode == 0:
			root = result.stdout.strip()
			if root:
				return Path(root)
	except OSError:
		pass
	return Path(__file__).resolve().parents[1]


def resolve_local_pyenv_version(repo_root: Path) -> str | None:
	version_file = repo_root / ".python-version"
	if not version_file.is_file():
		return None

	for line in version_file.read_text(encoding="utf-8").splitlines():
		version = line.strip()
		if version and not version.startswith("#"):
			return version
	return None


def choose_python_cmd(repo_root: Path) -> list[str] | None:
	pyenv_root = Path(os.environ.get("PYENV_ROOT", str(Path.home() / ".pyenv"))).expanduser()
	pyenv_bin = pyenv_root / "bin" / "pyenv"
	if pyenv_bin.is_file():
		os.environ["PYENV_ROOT"] = str(pyenv_root)
		current_path = os.environ.get("PATH", "")
		os.environ["PATH"] = f"{pyenv_root}/shims:{pyenv_root}/bin:{current_path}"
		local_pyenv_version = resolve_local_pyenv_version(repo_root)
		if local_pyenv_version:
			os.environ["PYENV_VERSION"] = local_pyenv_version
		return [str(pyenv_bin), "exec", "python"]

	if shutil.which("pyenv"):
		local_pyenv_version = resolve_local_pyenv_version(repo_root)
		if local_pyenv_version:
			os.environ["PYENV_VERSION"] = local_pyenv_version
		return ["pyenv", "exec", "python"]
	if shutil.which("python3"):
		return ["python3"]
	if shutil.which("python"):
		return ["python"]
	return None


def main() -> int:
	parser = argparse.ArgumentParser(
		description="Cria o virtualenv em ./venv usando pyenv quando disponivel.")
	parser.add_argument(
		"--recreate",
		action="store_true",
		help="Remove ./venv existente e cria novamente.",
	)
	args = parser.parse_args()

	repo_root = detect_repo_root()
	os.chdir(repo_root)
	venv_dir = repo_root / "venv"

	if args.recreate and venv_dir.is_dir():
		shutil.rmtree(venv_dir)

	if venv_dir.is_dir():
		print(f"venv ja existe em: {venv_dir}")
		return 0

	python_cmd = choose_python_cmd(repo_root)
	if not python_cmd:
		print("erro: python nao encontrado no PATH.")
		return 1

	print(f"criando virtualenv em: {venv_dir}")
	try:
		subprocess.run([*python_cmd, "-m", "venv", str(venv_dir)], check=True)
	except subprocess.CalledProcessError as exc:
		print(f"erro: falha ao criar ./venv (exit={exc.returncode}).")
		return exc.returncode or 1
	except OSError as exc:
		print(f"erro: falha ao executar comando de python: {exc}")
		return 1

	print("ok: virtualenv criado em ./venv")
	return 0


if __name__ == "__main__":
	sys.exit(main())
