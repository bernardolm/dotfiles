#!/usr/bin/env python3
from __future__ import annotations

from dataclasses import dataclass
import hashlib
import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import textwrap

from common import is_truthy


ROOT = Path(__file__).resolve().parents[1]
ZERO_SHA = "0" * 40
V1_PREFIX = ".v1/"


@dataclass(frozen=True)
class RefUpdate:
	local_ref: str
	local_sha: str
	remote_ref: str
	remote_sha: str


def main(
	remote_name: str = "",
	remote_url: str = "",
	instructions_file: str = "readme_update_guidelines.md",
	readme_file: str = "README.md",
	ai_command: str | None = None,
	ai_timeout_seconds: int | None = None,
	max_commits: int | None = None,
	dry_run: bool = False,
) -> int:
	os.chdir(ROOT)
	ai_command = ai_command or os.environ.get("DOTFILES_AI_DOCS_COMMAND", "codex")
	ai_timeout_seconds = ai_timeout_seconds or int(
		os.environ.get("DOTFILES_AI_DOCS_TIMEOUT_SECONDS", "240"))
	max_commits = max_commits or int(os.environ.get("DOTFILES_AI_DOCS_MAX_COMMITS", "80"))

	updates = _read_ref_updates(sys.stdin)
	if not updates:
		print("pre-push: nenhum update de referencia recebido; pulando IA de documentacao.")
		return 0

	commit_shas = _collect_commit_shas(updates, remote_name, max_commits)
	if not commit_shas:
		print("pre-push: nenhum commit novo relevante para documentar (fora de .v1).")
		return 0

	instructions_path = (ROOT / instructions_file).resolve()
	if not instructions_path.exists():
		print(f"pre-push: erro: arquivo de diretrizes nao encontrado: {instructions_path}")
		return 1

	readme_rel = readme_file.strip().lstrip("./") or "README.md"
	readme_path = (ROOT / readme_rel).resolve()
	if not readme_path.exists():
		print(f"pre-push: erro: arquivo README alvo nao encontrado: {readme_path}")
		return 1

	if shutil.which(ai_command) is None:
		print(f"pre-push: erro: comando de IA '{ai_command}' nao encontrado no PATH. "
					"Configure DOTFILES_AI_DOCS_COMMAND ou instale o comando.")
		return 1

	before_dirty = _dirty_files()
	before_dirty_hashes = _dirty_hashes(before_dirty)
	before_readme = readme_path.read_text(encoding="utf-8", errors="ignore")

	commit_lines = _commit_lines(commit_shas)
	if not commit_lines:
		print("pre-push: nao foi possivel coletar metadados dos commits; abortando.")
		return 1

	prompt = _build_prompt(
		instructions_path=instructions_path,
		readme_rel=readme_rel,
		remote_name=remote_name,
		remote_url=remote_url,
		commit_lines=commit_lines,
	)

	print(f"pre-push: IA de documentacao iniciando para {len(commit_shas)} commit(s) "
				f"com comando '{ai_command}'.")

	if dry_run:
		print("pre-push: dry-run ativo; nenhuma alteracao sera aplicada.")
		print("pre-push: commits considerados:")
		for line in commit_lines:
			print(f"- {line}")
		return 0

	result = _run_ai_command(
		ai_command=ai_command,
		prompt=prompt,
		timeout_seconds=ai_timeout_seconds,
	)
	if result != 0:
		return result

	after_dirty = _dirty_files()
	after_readme = readme_path.read_text(encoding="utf-8", errors="ignore")

	new_dirty = after_dirty - before_dirty
	mutated_pre_dirty = {
		item for item in before_dirty
		if item in after_dirty and _file_digest(item) != before_dirty_hashes.get(item)
	}
	unexpected_changes = sorted((new_dirty | mutated_pre_dirty) - {readme_rel})

	if unexpected_changes:
		print("pre-push: erro: a IA alterou arquivos fora do README alvo.")
		for item in unexpected_changes:
			print(f"- {item}")
		print("pre-push: revise as alteracoes, ajuste manualmente e tente o push novamente.")
		return 1

	if after_readme != before_readme:
		print(f"pre-push: {readme_rel} foi atualizado pela IA com base nos commits do push.")
		print("pre-push: revise, faça commit do README e execute o push novamente.")
		return 1

	print("pre-push: README ja estava alinhado; push liberado.")
	return 0


def _read_ref_updates(stream: object) -> list[RefUpdate]:
	updates: list[RefUpdate] = []
	for raw in stream:
		line = str(raw).strip()
		if not line:
			continue
		parts = line.split()
		if len(parts) != 4:
			print(f"pre-push: aviso: linha de update invalida ignorada: {line}")
			continue
		updates.append(
			RefUpdate(
				local_ref=parts[0],
				local_sha=parts[1],
				remote_ref=parts[2],
				remote_sha=parts[3],
			))
	return updates


def _collect_commit_shas(
	updates: list[RefUpdate],
	remote_name: str,
	max_commits: int,
) -> list[str]:
	ordered: list[str] = []
	seen: set[str] = set()

	for update in updates:
		if update.local_sha == ZERO_SHA:
			continue

		if update.remote_sha != ZERO_SHA:
			cmd = ["rev-list", "--reverse", f"{update.remote_sha}..{update.local_sha}"]
		else:
			if remote_name.strip():
				cmd = [
					"rev-list",
					"--reverse",
					update.local_sha,
					"--not",
					f"--remotes={remote_name.strip()}",
				]
			else:
				cmd = ["rev-list", "--reverse", update.local_sha, "--not", "--remotes"]

		shas = _git_lines(cmd, check=False)
		if not shas:
			shas = _git_lines(["rev-list", "--reverse", "--max-count", "30", update.local_sha],
												check=False)

		for sha in shas:
			if sha in seen:
				continue
			if not _commit_has_non_v1_changes(sha):
				continue
			seen.add(sha)
			ordered.append(sha)
			if len(ordered) >= max_commits:
				return ordered

	return ordered


def _commit_has_non_v1_changes(sha: str) -> bool:
	paths = _git_lines(["diff-tree", "--root", "--no-commit-id", "--name-only", "-r", sha],
											check=False)
	if not paths:
		return False
	for path in paths:
		if not _is_v1_path(path):
			return True
	return False


def _commit_lines(commit_shas: list[str]) -> list[str]:
	lines: list[str] = []
	for sha in commit_shas:
		output = _git_lines(["show", "-s", "--date=short", "--format=%h | %ad | %an | %s", sha],
												check=False)
		if output:
			lines.append(output[0])
	return lines


def _build_prompt(
	instructions_path: Path,
	readme_rel: str,
	remote_name: str,
	remote_url: str,
	commit_lines: list[str],
) -> str:
	instructions = instructions_path.read_text(encoding="utf-8", errors="ignore").strip()
	commits_block = "\n".join(f"- {line}" for line in commit_lines)

	return textwrap.dedent(f"""
	\tVoce esta executando uma atualizacao automatica de documentacao antes de um git push.
	\tAtualize somente o arquivo `{readme_rel}` neste repositorio.
	\tIgnore completamente a pasta `.v1/` (arquivo historico, sem manutencao ativa).
	\tNao leia, nao cite e nao proponha alteracoes para qualquer caminho em `.v1/`.

	\tSiga obrigatoriamente estas diretrizes (fonte oficial):
	\t--- INICIO DIRETRIZES ---
	\t{instructions}
	\t--- FIM DIRETRIZES ---

	\tContexto do push:
	\t- remote_name: {remote_name or "(nao informado)"}
	\t- remote_url: {remote_url or "(nao informado)"}

	\tCommits que serao enviados:
	\t{commits_block}

	\tObjetivo desta execucao:
	\t- refletir no README o proposito real do repositorio;
	\t- explicar claramente o que ele configura, em quais sistemas e com quais ferramentas;
	\t- manter texto objetivo, tecnico e fiel ao estado atual do codigo.

	\tRestrições finais:
	\t- nao alterar qualquer arquivo alem de `{readme_rel}`;
	\t- ignorar completamente `.v1/`;
	\t- nao criar commit;
	\t- nao inventar funcionalidades inexistentes.
	""").strip()


def _run_ai_command(ai_command: str, prompt: str, timeout_seconds: int) -> int:
	cmd = [ai_command, "exec", "--full-auto", "-C", str(ROOT), prompt]
	print("pre-push: executando:", " ".join(shlex.quote(item) for item in cmd[:5]), "<PROMPT>")
	try:
		completed = subprocess.run(cmd, check=False, cwd=str(ROOT), timeout=timeout_seconds)
	except subprocess.TimeoutExpired:
		print(f"pre-push: erro: comando de IA excedeu timeout de {timeout_seconds}s.")
		return 1
	except OSError as exc:
		print(f"pre-push: erro ao executar IA: {exc}")
		return 1

	if completed.returncode != 0:
		print(f"pre-push: erro: comando de IA retornou codigo {completed.returncode}.")
		return completed.returncode
	return 0


def _dirty_files() -> set[str]:
	lines = _git_lines(["status", "--porcelain"], check=False)
	items: set[str] = set()
	for line in lines:
		if len(line) < 4:
			continue
		path_part = line[3:]
		if " -> " in path_part:
			path_part = path_part.split(" -> ", 1)[1]
		path = path_part.strip()
		if path:
			items.add(path)
	return items


def _dirty_hashes(paths: set[str]) -> dict[str, str | None]:
	return {
		path: _file_digest(path) for path in paths
	}


def _file_digest(path: str) -> str | None:
	full_path = ROOT / path
	if not full_path.exists() or not full_path.is_file():
		return None
	hasher = hashlib.sha256()
	with full_path.open("rb") as handle:
		for chunk in iter(lambda: handle.read(8192), b""):
			hasher.update(chunk)
	return hasher.hexdigest()


def _git_lines(args: list[str], check: bool) -> list[str]:
	cmd = ["git", *args]
	try:
		completed = subprocess.run(
			cmd,
			check=False,
			stdout=subprocess.PIPE,
			stderr=subprocess.PIPE,
			text=True,
			cwd=str(ROOT),
		)
	except OSError:
		return []

	if check and completed.returncode != 0:
		error_text = completed.stderr.strip() or completed.stdout.strip()
		if error_text:
			print(f"pre-push: erro git {' '.join(args)}: {error_text}")
		return []

	if completed.returncode != 0:
		return []

	return [line.strip() for line in completed.stdout.splitlines() if line.strip()]


def _is_v1_path(path: str) -> bool:
	return path == ".v1" or path.startswith(V1_PREFIX)


if __name__ == "__main__":
	raise SystemExit(
		main(
			remote_name=os.environ.get("DOTFILES_PRE_PUSH_REMOTE_NAME", ""),
			remote_url=os.environ.get("DOTFILES_PRE_PUSH_REMOTE_URL", ""),
			dry_run=is_truthy(os.environ.get("DOTFILES_AI_DOCS_DRY_RUN", "0")),
		))
