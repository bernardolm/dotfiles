#!/usr/bin/env python3
from __future__ import annotations

from dataclasses import dataclass
from datetime import date
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import textwrap

from common import is_truthy


ROOT = Path(__file__).resolve().parents[1]
ZERO_SHA = "0" * 40
V1_PREFIX = ".v1/"
README_UPDATES_START = "<!-- docs-ai-updates:start -->"
README_UPDATES_END = "<!-- docs-ai-updates:end -->"
README_UPDATE_ID_PREFIX = "<!-- docs-ai-update:"
README_UPDATE_ID_SUFFIX = " -->"


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
	max_commits = max_commits or int(os.environ.get("DOTFILES_AI_DOCS_MAX_COMMITS", "25"))
	_log("docs-sync iniciado.")

	updates = _read_ref_updates(sys.stdin)
	if not updates:
		_log("sem atualizacoes de refs para processar.")
		return 0

	commit_shas = _collect_commit_shas(updates, remote_name, max_commits)
	if not commit_shas:
		_log("sem commits relevantes para documentacao.")
		return 0
	_log(f"{len(commit_shas)} commit(s) relevante(s) para README.")

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

	if dry_run:
		_log(f"dry-run: IA nao executada ({len(commit_shas)} commit(s) analisado(s)).")
		return 0

	_log("gerando resumo incremental com IA...")
	summary_markdown = _run_ai_summary_command(
		ai_command=ai_command,
		prompt=prompt,
		timeout_seconds=ai_timeout_seconds,
	)
	if summary_markdown is None:
		return 1

	changed = _append_incremental_readme_update(
		readme_path=readme_path,
		remote_name=remote_name,
		remote_url=remote_url,
		commit_lines=commit_lines,
		summary_markdown=summary_markdown,
	)
	if not changed:
		_log("README ja estava alinhado; nenhuma atualizacao necessaria.")
		return 0

	after_dirty = _dirty_files()

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

	_log(
		f"{readme_rel} recebeu atualizacao incremental; revise, faca commit e rode o push novamente.")
	return 1


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
	\tContexto do push:
	\t- arquivo_alvo: {readme_rel}
	\t- remote_name: {remote_name or "(nao informado)"}
	\t- remote_url: {remote_url or "(nao informado)"}

	\tCommits que serao enviados:
	\t{commits_block}

	\tDiretrizes obrigatorias (fonte oficial):
	\t{instructions}
	""").strip()


def _run_ai_summary_command(ai_command: str, prompt: str, timeout_seconds: int) -> str | None:
	with tempfile.NamedTemporaryFile(
		prefix="docs_ai_sync_",
		suffix=".md",
		delete=False,
		dir=str(ROOT),
	) as handle:
		output_file = Path(handle.name)

	cmd = [
		ai_command,
		"exec",
		"--sandbox",
		"read-only",
		"--color",
		"never",
		"-C",
		str(ROOT),
		"-o",
		str(output_file),
		prompt,
	]
	if Path(ai_command).name == "codex":
		cmd[3:3] = [
			"-c", 'model_reasoning_effort="medium"', "-c", 'model_verbosity="low"', "--diff-verbosity",
			"step"
		]
	try:
		completed = subprocess.run(
			cmd,
			check=False,
			cwd=str(ROOT),
			timeout=timeout_seconds,
			stdout=subprocess.DEVNULL,
			stderr=subprocess.DEVNULL,
		)
	except subprocess.TimeoutExpired:
		print(f"pre-push: erro: comando de IA excedeu timeout de {timeout_seconds}s.")
		_unlink_quietly(output_file)
		return None
	except OSError as exc:
		print(f"pre-push: erro ao executar IA: {exc}")
		_unlink_quietly(output_file)
		return None

	if completed.returncode != 0:
		print(f"pre-push: erro: comando de IA falhou (codigo {completed.returncode}).")
		_unlink_quietly(output_file)
		return None

	summary = output_file.read_text(encoding="utf-8", errors="ignore")
	_unlink_quietly(output_file)
	summary = _normalize_ai_summary(summary)
	if not summary:
		print("pre-push: erro: IA retornou resumo vazio.")
		return None
	return summary


def _append_incremental_readme_update(
	readme_path: Path,
	remote_name: str,
	remote_url: str,
	commit_lines: list[str],
	summary_markdown: str,
) -> bool:
	summary_markdown = _normalize_ai_summary(summary_markdown)
	if not summary_markdown:
		return False
	if summary_markdown.strip().upper() == "SKIP":
		return False

	entry_id = hashlib.sha256("\n".join(commit_lines).encode("utf-8")).hexdigest()[:12]
	entry_marker = _entry_marker(entry_id)

	content = readme_path.read_text(encoding="utf-8", errors="ignore")
	content = _ensure_incremental_updates_block(content)
	if entry_marker in content:
		return False

	start_index = content.find(README_UPDATES_START)
	end_index = content.find(README_UPDATES_END, start_index)
	if start_index < 0 or end_index < 0:
		print("pre-push: erro: bloco de atualizacoes incrementais do README nao encontrado.")
		return False

	commit_excerpt = commit_lines[:8]
	commit_block = "\n".join(f"- {line}" for line in commit_excerpt)
	summary_block = _to_bullet_block(summary_markdown)

	remote_name_value = remote_name.strip() or "(nao informado)"
	remote_url_value = remote_url.strip() or "(nao informado)"
	entry = "\n".join([
		entry_marker,
		f"### {date.today().isoformat()} | {remote_name_value}",
		f"- remote_url: `{remote_url_value}`",
		"Commits:",
		commit_block,
		"Resumo:",
		summary_block,
		"",
	])

	block_start = start_index + len(README_UPDATES_START)
	current_block = content[block_start:end_index]
	updated_block = "\n\n" + entry + current_block.lstrip("\n")
	updated_content = content[:block_start] + updated_block + content[end_index:]
	readme_path.write_text(updated_content, encoding="utf-8")
	return True


def _ensure_incremental_updates_block(content: str) -> str:
	if README_UPDATES_START in content and README_UPDATES_END in content:
		return content

	section = textwrap.dedent("""
	## atualizacoes incrementais (pre-push IA)

	<!-- docs-ai-updates:start -->
	<!-- docs-ai-updates:end -->
	""").strip()

	base = content.rstrip()
	if base:
		return f"{base}\n\n{section}\n"
	return f"{section}\n"


def _normalize_ai_summary(raw_text: str) -> str:
	text = raw_text.strip()
	if not text:
		return ""

	lines = text.splitlines()
	if lines and lines[0].strip().startswith("```"):
		lines = lines[1:]
	if lines and lines[-1].strip() == "```":
		lines = lines[:-1]

	cleaned: list[str] = []
	for line in lines:
		item = line.strip()
		if not item:
			continue
		if item.startswith("#"):
			continue
		cleaned.append(item)
		if len(cleaned) >= 12:
			break
	return "\n".join(cleaned).strip()


def _to_bullet_block(text: str) -> str:
	lines = [line.strip() for line in text.splitlines() if line.strip()]
	if not lines:
		return "- (sem resumo)"
	result: list[str] = []
	for line in lines:
		if line.startswith("- "):
			result.append(line)
		else:
			result.append(f"- {line}")
	return "\n".join(result)


def _entry_marker(entry_id: str) -> str:
	return f"{README_UPDATE_ID_PREFIX}{entry_id}{README_UPDATE_ID_SUFFIX}"


def _unlink_quietly(path: Path) -> None:
	try:
		path.unlink(missing_ok=True)
	except OSError:
		return


def _log(message: str) -> None:
	print(f"pre-push: {message}")


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
