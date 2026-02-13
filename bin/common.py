from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess
import sys
from typing import Iterable, Sequence


def repo_root(start: Path | None = None) -> Path:
	start = (start or Path(__file__).resolve()).resolve()
	for parent in [start] + list(start.parents):
		if (parent / ".git").exists():
			return parent
	return start.parent


def dotfiles_root() -> Path:
	return Path.home() / "dotfiles"


def detect_os() -> str:
	prefix = os.environ.get("PREFIX", "")
	if os.environ.get("TERMUX_VERSION") or prefix.startswith("/data/data/com.termux"):
		return "termux"
	if sys.platform == "darwin":
		return "darwin"
	if sys.platform.startswith("linux"):
		try:
			version = Path("/proc/version").read_text(encoding="utf-8", errors="ignore").lower()
		except OSError:
			version = ""
		if "microsoft" in version or os.environ.get("WSL_DISTRO_NAME"):
			return "wsl"
		return "linux"
	if sys.platform in {"win32", "cygwin"}:
		return "windows"
	return "unknown"


def run(
	cmd: Sequence[str],
	check: bool = False,
	capture: bool = False,
	text: bool = True,
	input_data: str | None = None,
	env: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
	return subprocess.run(
		list(cmd),
		check=check,
		capture_output=capture,
		text=text,
		input=input_data,
		env=env,
	)


def run_lines(cmd: Sequence[str], check: bool = False) -> list[str]:
	result = run(cmd, check=check, capture=True)
	return [line for line in result.stdout.splitlines() if line]


def run_pipeline(cmds: list[Sequence[str]], input_data: str | None = None) -> tuple[str, int]:
	if not cmds:
		return "", 0

	procs: list[subprocess.Popen[str]] = []
	prev: subprocess.Popen[str] | None = None
	for cmd in cmds:
		proc = subprocess.Popen(
			list(cmd),
			stdin=prev.stdout if prev else None,
			stdout=subprocess.PIPE,
			stderr=subprocess.PIPE,
			text=True,
		)
		if prev and prev.stdout:
			prev.stdout.close()
		procs.append(proc)
		prev = proc

	stdout, _stderr = procs[-1].communicate(input_data)
	return stdout or "", procs[-1].returncode


def which(cmd: str) -> str | None:
	return shutil.which(cmd)


def ensure_dir(path: Path) -> None:
	path.mkdir(parents=True, exist_ok=True)


def remove_paths(paths: Iterable[Path]) -> None:
	for path in paths:
		try:
			if path.is_dir() and not path.is_symlink():
				shutil.rmtree(path)
			else:
				path.unlink()
		except FileNotFoundError:
			continue


def is_truthy(value: str | None) -> bool:
	return str(value or "0").lower() in {"1", "true", "yes", "on"}


def tmp_user_root() -> Path:
	return Path(os.environ.get("TMP_USER", str(Path.home() / "sync/tmp/unknown")))


def last_backup_version(name: str, ext: str) -> str:
	root = Path.home() / "sync/linux" / name
	root.mkdir(parents=True, exist_ok=True)
	candidates = list(root.glob(f"*.{ext}"))
	if candidates:
		latest = max(candidates, key=lambda p: p.stat().st_mtime)
		return str(latest)
	return str(root / f"{name}_current.{ext}")
