#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
import platform
import shlex
import shutil
import subprocess


def strip_jsonc_comments(content: str) -> str:
	result: list[str] = []
	in_string = False
	escaped = False
	i = 0

	while i < len(content):
		ch = content[i]
		nxt = content[i + 1] if i + 1 < len(content) else ""

		if in_string:
			result.append(ch)
			if escaped:
				escaped = False
			elif ch == "\\":
				escaped = True
			elif ch == '"':
				in_string = False
			i += 1
			continue

		if ch == '"':
			in_string = True
			result.append(ch)
			i += 1
			continue

		if ch == "/" and nxt == "/":
			i += 2
			while i < len(content) and content[i] != "\n":
				i += 1
			continue

		if ch == "/" and nxt == "*":
			i += 2
			while i + 1 < len(content) and not (content[i] == "*" and content[i + 1] == "/"):
				i += 1
			i += 2
			continue

		result.append(ch)
		i += 1

	return "".join(result)


def strip_trailing_commas(content: str) -> str:
	result: list[str] = []
	in_string = False
	escaped = False
	i = 0

	while i < len(content):
		ch = content[i]

		if in_string:
			result.append(ch)
			if escaped:
				escaped = False
			elif ch == "\\":
				escaped = True
			elif ch == '"':
				in_string = False
			i += 1
			continue

		if ch == '"':
			in_string = True
			result.append(ch)
			i += 1
			continue

		if ch == ",":
			j = i + 1
			while j < len(content) and content[j].isspace():
				j += 1
			if j < len(content) and content[j] in "]}":
				i += 1
				continue

		result.append(ch)
		i += 1

	return "".join(result)


def load_extensions(file_path: Path) -> list[str]:
	raw = file_path.read_text(encoding="utf-8")
	normalized = strip_trailing_commas(strip_jsonc_comments(raw))
	data = json.loads(normalized)

	if isinstance(data, dict):
		items = data.get("recommendations", [])
	elif isinstance(data, list):
		items = data
	else:
		raise ValueError(
			f"Formato inválido em {file_path}: esperado array ou objeto com recommendations.")

	if not isinstance(items, list):
		raise ValueError(f"'recommendations' deve ser uma lista em {file_path}.")

	unique: list[str] = []
	seen: set[str] = set()
	for item in items:
		if not isinstance(item, str):
			continue
		ext = item.strip()
		if not ext or ext in seen:
			continue
		seen.add(ext)
		unique.append(ext)
	return unique


def list_installed_extensions(code_bin: str) -> set[str] | None:
	proc = subprocess.run([code_bin, "--list-extensions"], capture_output=True, text=True)
	if proc.returncode != 0:
		output = (proc.stderr or proc.stdout).strip()
		print(
			"Aviso: não foi possível listar extensões instaladas; remoções serão tentadas diretamente.")
		if output:
			print(f"  {output.splitlines()[-1]}")
		return None

	return {line.strip() for line in proc.stdout.splitlines() if line.strip()}


def parse_extension_action(raw_extension: str) -> tuple[str, str]:
	# Sufixo "-" marca a extensao para remocao.
	if raw_extension.endswith("-"):
		return "remove", raw_extension[:-1].strip()
	return "install", raw_extension


def sync_extensions(extensions: list[str],
										code_bin: str,
										force: bool = True,
										dry_run: bool = False) -> int:
	failures: list[str] = []
	warnings: list[str] = []
	total = len(extensions)
	installed_extensions = None if dry_run else list_installed_extensions(code_bin)
	install_count = 0
	remove_count = 0

	for idx, raw_ext in enumerate(extensions, start=1):
		action, ext = parse_extension_action(raw_ext)
		if not ext:
			warnings.append(raw_ext)
			print(f"[{idx}/{total}] Aviso: entrada inválida '{raw_ext}', ignorando.")
			continue

		action_label = "Removendo" if action == "remove" else "Instalando"
		log_prefix = f"[{idx}/{total}] {action_label}: {ext}"

		if action == "remove":
			remove_count += 1
			print(log_prefix, end="", flush=True)
			if installed_extensions is not None and ext not in installed_extensions:
				warnings.append(ext)
				print(" - AVISO: extensão já não estava instalada")
				continue
			cmd = [code_bin, "--uninstall-extension", ext]
		else:
			install_count += 1
			cmd = [code_bin, "--install-extension", ext]
			if force:
				cmd.append("--force")
			print(log_prefix, end="", flush=True)

		if dry_run:
			if os.name == "nt":
				printable_cmd = subprocess.list2cmdline(cmd)
			else:
				printable_cmd = shlex.join(cmd)
			print(" - DRY-RUN")
			print(f"  {printable_cmd}")
			continue

		proc = subprocess.run(cmd, capture_output=True, text=True)
		if proc.returncode == 0:
			if action == "remove" and installed_extensions is not None:
				installed_extensions.discard(ext)
			if action == "install" and installed_extensions is not None:
				installed_extensions.add(ext)
			print(" - OK")
			continue

		output = (proc.stderr or proc.stdout).strip()
		if action == "remove" and "not installed" in output.lower():
			warnings.append(ext)
			print(" - AVISO: extensão já não estava instalada")
			continue

		failures.append(ext)
		print(f" - FALHOU (exit={proc.returncode})")
		if output:
			print(f"  {output.splitlines()[-1]}")

	print("")
	print(f"Total: {total}")
	print(f"Instalações: {install_count}")
	print(f"Remoções: {remove_count}")
	print(f"Avisos: {len(warnings)}")
	print(f"Sucesso: {total - len(failures)}")
	print(f"Falhas: {len(failures)}")
	if warnings:
		print("Extensões com aviso:")
		for ext in warnings:
			print(f"- {ext}")
	if failures:
		print("Extensões com falha:")
		for ext in failures:
			print(f"- {ext}")
		return 1
	return 0


def detect_code_binary(provided: str | None) -> str | None:
	if provided:
		resolved = shutil.which(provided)
		if resolved:
			return resolved

		provided_path = Path(provided).expanduser()
		if provided_path.is_file():
			return str(provided_path)
		return None

	for candidate in ("code", "code-insiders", "codium"):
		resolved = shutil.which(candidate)
		if resolved:
			return resolved

	for candidate in default_code_cli_locations():
		if candidate.is_file():
			return str(candidate)
	return None


def default_code_cli_locations() -> list[Path]:
	os_name = platform.system().lower()
	locations: list[Path] = []

	if os_name == "windows":
		env_paths = [
			os.environ.get("LOCALAPPDATA"),
			os.environ.get("PROGRAMFILES"),
			os.environ.get("PROGRAMFILES(X86)"),
		]
		suffixes = [
			Path("Programs/Microsoft VS Code/bin/code.cmd"),
			Path("Programs/Microsoft VS Code Insiders/bin/code-insiders.cmd"),
			Path("VSCodium/bin/codium.cmd"),
			Path("Microsoft VS Code/bin/code.cmd"),
			Path("Microsoft VS Code Insiders/bin/code-insiders.cmd"),
		]
		for base in env_paths:
			if not base:
				continue
			base_path = Path(base)
			for suffix in suffixes:
				locations.append(base_path / suffix)
		return locations

	if os_name == "darwin":
		locations.extend([
			Path("/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"),
			Path(
				"/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"),
			Path("/Applications/VSCodium.app/Contents/Resources/app/bin/codium"),
			Path.home() / "Applications/Visual Studio Code.app/Contents/Resources/app/bin/code",
			Path.home() /
			"Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders",
			Path.home() / "Applications/VSCodium.app/Contents/Resources/app/bin/codium",
		])
		return locations

	locations.extend([
		Path("/usr/bin/code"),
		Path("/usr/bin/code-insiders"),
		Path("/usr/bin/codium"),
		Path("/snap/bin/code"),
		Path("/snap/bin/code-insiders"),
		Path("/snap/bin/codium"),
	])
	return locations


def _is_truthy(value: str | None) -> bool:
	if value is None:
		return False
	return value.strip().lower() in {"1", "true", "yes", "y", "on"}


def main(
	extensions_file: str | Path | None = None,
	code_bin: str | None = None,
	force: bool | None = None,
	dry_run: bool | None = None,
) -> int:
	default_extensions_file = Path(__file__).resolve().parents[1] / ".vscode" / "extensions.json"
	resolved_extensions_file = Path(extensions_file or os.environ.get(
		"DOTFILES_VSCODE_EXTENSIONS_FILE", str(default_extensions_file))).expanduser()
	resolved_code_bin = detect_code_binary(code_bin or os.environ.get("DOTFILES_VSCODE_CODE_BIN"))
	resolved_force = force
	if resolved_force is None:
		resolved_force = not _is_truthy(os.environ.get("DOTFILES_VSCODE_NO_FORCE", "0"))
	resolved_dry_run = dry_run if dry_run is not None else _is_truthy(
		os.environ.get("DOTFILES_DRY_RUN") or os.environ.get("DOTFILES_VSCODE_DRY_RUN", "0"))

	code_bin = resolved_code_bin
	if not code_bin:
		print(
			"CLI do VS Code não encontrada. Defina DOTFILES_VSCODE_CODE_BIN ou adicione 'code' ao PATH.")
		return 2

	extensions_file = resolved_extensions_file
	if not extensions_file.exists():
		print(f"Arquivo não encontrado: {extensions_file}")
		return 2

	try:
		extensions = load_extensions(extensions_file)
	except (OSError, json.JSONDecodeError, ValueError) as exc:
		print(f"Falha ao carregar extensões de {extensions_file}: {exc}")
		return 2

	if not extensions:
		print(f"Nenhuma extensão encontrada em: {extensions_file}")
		return 0

	return sync_extensions(
		extensions,
		code_bin=code_bin,
		force=resolved_force,
		dry_run=resolved_dry_run,
	)


if __name__ == "__main__":
	raise SystemExit(main())
