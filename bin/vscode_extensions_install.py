#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import platform
import shlex
import shutil
import subprocess
from pathlib import Path


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
        raise ValueError(f"Formato inválido em {file_path}: esperado array ou objeto com recommendations.")

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


def install_extensions(extensions: list[str], code_bin: str, force: bool = True, dry_run: bool = False) -> int:
    failures: list[str] = []
    total = len(extensions)

    for idx, ext in enumerate(extensions, start=1):
        cmd = [code_bin, "--install-extension", ext]
        if force:
            cmd.append("--force")

        print(f"[{idx}/{total}] Instalando: {ext}")
        if dry_run:
            if os.name == "nt":
                printable_cmd = subprocess.list2cmdline(cmd)
            else:
                printable_cmd = shlex.join(cmd)
            print("  DRY-RUN:", printable_cmd)
            continue

        proc = subprocess.run(cmd, capture_output=True, text=True)
        if proc.returncode == 0:
            print("  OK")
            continue

        failures.append(ext)
        print(f"  FALHOU (exit={proc.returncode})")
        error_output = (proc.stderr or proc.stdout).strip()
        if error_output:
            print(f"  {error_output.splitlines()[-1]}")

    print("")
    print(f"Total: {total}")
    print(f"Sucesso: {total - len(failures)}")
    print(f"Falhas: {len(failures)}")
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
            Path("/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"),
            Path("/Applications/VSCodium.app/Contents/Resources/app/bin/codium"),
            Path.home() / "Applications/Visual Studio Code.app/Contents/Resources/app/bin/code",
            Path.home() / "Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders",
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


if __name__ == "__main__":
    default_extensions_file = Path(__file__).resolve().parents[1] / ".vscode" / "extensions.json"

    parser = argparse.ArgumentParser(
        description="Instala extensões do VS Code definidas em um arquivo extensions.json (JSON/JSONC)."
    )
    parser.add_argument(
        "--file",
        default=str(default_extensions_file),
        help="Caminho do extensions.json (padrão: ./dotfiles/.vscode/extensions.json).",
    )
    parser.add_argument(
        "--code-bin",
        default=None,
        help="Binário do VS Code CLI (ex: code, code-insiders, codium). Detecta automaticamente se omitido.",
    )
    parser.add_argument("--no-force", action="store_true", help="Não usar --force ao instalar extensões.")
    parser.add_argument("--dry-run", action="store_true", help="Mostra os comandos sem executar.")
    args = parser.parse_args()

    code_bin = detect_code_binary(args.code_bin)
    if not code_bin:
        print("CLI do VS Code não encontrada. Informe com --code-bin ou adicione 'code' ao PATH.")
        raise SystemExit(2)

    extensions_file = Path(args.file).expanduser()
    if not extensions_file.exists():
        print(f"Arquivo não encontrado: {extensions_file}")
        raise SystemExit(2)

    extensions = load_extensions(extensions_file)
    if not extensions:
        print(f"Nenhuma extensão encontrada em: {extensions_file}")
        raise SystemExit(0)

    raise SystemExit(
        install_extensions(
            extensions,
            code_bin=code_bin,
            force=not args.no_force,
            dry_run=args.dry_run,
        )
    )
