#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
import re

from common import git_staged_files, repo_root


_WORKFLOW_RE = re.compile(r"^\.github/workflows/.*\.(yml|yaml)$")
_V1_IGNORE_RE = re.compile(r"\.v1/\*\*|\.v1/")
_SHELL_REQUIRED_RE = re.compile(r"shell-required:")


def _is_shell_script(path: Path) -> bool:
	name = path.name
	if name.endswith((".sh", ".bash", ".zsh", ".ksh")):
		return True
	if not path.is_file():
		return False
	try:
		first_line = path.read_text(encoding="utf-8", errors="ignore").splitlines()[0]
	except Exception:
		return False
	first_line = first_line.strip()
	if not first_line.startswith("#!"):
		return False
	return any(token in first_line for token in ("sh", "bash", "zsh", "ksh"))


def _has_shell_required_marker(path: Path) -> bool:
	try:
		lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
	except OSError:
		return False
	head = "\n".join(lines[:30])
	return _SHELL_REQUIRED_RE.search(head) is not None


def _validate_workflows(staged_files: list[str]) -> int:
	invalid = False
	for file in staged_files:
		if _WORKFLOW_RE.match(file) is None:
			continue
		path = Path(file)
		if not path.is_file():
			continue
		content = path.read_text(encoding="utf-8", errors="ignore")
		if _V1_IGNORE_RE.search(content) is None:
			print(f"pre-commit: erro: workflow sem exclusao explicita de .v1: {file}")
			invalid = True
	if invalid:
		print("pre-commit: adicione 'paths-ignore' com '.v1/**' no(s) workflow(s) acima.")
		return 1
	return 0


def _validate_new_shell_scripts(staged_added_files: list[str]) -> int:
	invalid = False
	for file in staged_added_files:
		path = Path(file)
		if not path.is_file():
			continue
		if not _is_shell_script(path):
			continue
		if not _has_shell_required_marker(path):
			print(f"pre-commit: erro: novo script shell sem justificativa tecnica: {file}")
			invalid = True
	if invalid:
		print("pre-commit: regra ativa: novos scripts devem ser Python por padrao.")
		print("pre-commit: use shell so quando necessario e adicione no topo do arquivo:")
		print("pre-commit:   # shell-required: <motivo tecnico de por que Python nao atende bem>")
		return 1
	return 0


def main(staged_files: list[str] | None = None, staged_added_files: list[str] | None = None) -> int:
	root = repo_root(Path(__file__).resolve())
	staged_files = staged_files if staged_files is not None else git_staged_files(
		root,
		diff_filter="ACMR",
	)
	staged_added_files = staged_added_files if staged_added_files is not None else git_staged_files(
		root,
		diff_filter="A",
	)

	if _validate_workflows(staged_files) != 0:
		return 1
	if _validate_new_shell_scripts(staged_added_files) != 0:
		return 1
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
