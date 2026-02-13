from __future__ import annotations

import json
import os
import random
import re
import time
from pathlib import Path
from urllib.parse import parse_qs, urlparse

from pyfunctions.common import last_backup_version, run, tmp_user_root
from pyfunctions.zsh import color_value, now_value


def git_checkout_pristine(argv: list[str]) -> int:
	if not argv:
	return 1
	next_commit = argv[0]
	run(["/usr/bin/git", "checkout", "."], check=False)
	run(["/usr/bin/git", "clean", "-fdx"], check=False)
	return run(["/usr/bin/git", "checkout", next_commit]).returncode


def _log_file_start(log_file: Path) -> None:
	colors = [
	"red",
	"green",
	"brown",
	"blue",
	"purple",
	"cyan",
	"light_gray",
	"gray",
	"rose",
	"light_green",
	"yellow",
	"light_blue",
	"light_purple",
	"light_cyan",
	"white",
	]
	log_file.write_text(color_value(random.choice(colors)))


def _log_file_finalize(log_file: Path, only_last_line: bool) -> None:
	with log_file.open("a") as handle:
	handle.write("\n" + color_value("no"))
	lines = log_file.read_text(errors="ignore").splitlines()
	if only_last_line:
	sample = []
	if lines:
		sample.append(lines[0])
	if len(lines) >= 2:
		sample.append(lines[-2])
	if len(lines) >= 1:
		sample.append(lines[-1])
	print("\n".join(sample))
	else:
	print("\n".join(lines))


def _git_clone(repo_name: str, repo_url: str, dest_root: str, log_root: Path) -> None:
	log_file = log_root / f"{repo_name}.log"
	log_file.touch()
	_log_file_start(log_file)

	with log_file.open("a") as handle:
	handle.write(f"cloning from {repo_url} to {dest_root}/{repo_name}")

	with log_file.open("a") as handle:
	import subprocess

	subprocess.run(
		["git", "clone", "--progress", repo_url, f"{dest_root}/{repo_name}"],
		stdout=handle,
		stderr=handle,
		text=True,
		check=False,
	)

	content = log_file.read_text(errors="ignore")
	if "make sure you have the correct access rights" in content:
	with log_file.open("a") as handle:
		handle.write(f"\n\U0001F512 {repo_name} blocked, you can't see this")
	_log_file_finalize(log_file, only_last_line=True)
	return
	if "is not an empty directory" in content:
	with log_file.open("a") as handle:
		handle.write(f"\n\u2705  {repo_name} repository already exist")
	_log_file_finalize(log_file, only_last_line=True)
	return

	_log_file_finalize(log_file, only_last_line=False)


def _fetch_page(url: str, dest: Path, page: str, github_user: str, token: str) -> tuple[Path, Path]:
	headers = dest / f"page_{page}.txt"
	payload = dest / f"page_{page}.json"
	run(
	[
		"curl",
		"-s",
		"-u",
		f"{github_user}:{token}",
		"-D",
		str(headers),
		"-o",
		str(payload),
		url,
	],
	check=False,
	)
	return headers, payload


def _next_page_from_headers(headers: Path) -> str:
	for line in headers.read_text(errors="ignore").splitlines():
	if "link:" not in line.lower():
		continue
	match = re.search(r"<(http[^>]+)>;\s*rel=\"next\"", line)
	if match:
		return match.group(1)
	return ""


def git_clone_repos_by_url(argv: list[str]) -> int:
	if len(argv) < 2:
	print("URL is required, nothing to do by now" if not argv else "dest path is required, nothing to do by now")
	return 1

	url = argv[0]
	dest = argv[1]

	parsed = urlparse(url)
	page = parse_qs(parsed.query).get("page", [""])[0]
	if not page:
	print("page can't be found, nothing to do by now")
	return 1

	destination_path = tmp_user_root() / "git-clone" / now_value()
	destination_path.mkdir(parents=True, exist_ok=True)

	token = run(["git", "config", "github.token"], capture=True).stdout.strip()
	github_user = os.environ.get("GITHUB_USER", "")

	print(f"\U0001F30E downloading page {page} from {url} to {dest}...")

	headers, payload = _fetch_page(url, destination_path, page, github_user, token)

	try:
	data = json.loads(payload.read_text(errors="ignore"))
	except json.JSONDecodeError:
	data = []

	for item in data:
	name = item.get("name")
	ssh_url = item.get("ssh_url")
	if not name or not ssh_url:
		continue
	_git_clone(name, ssh_url, dest, destination_path)

	next_page = _next_page_from_headers(headers)
	if not next_page:
	print("\U0001F3C1  finished pages downloading")
	return 0

	return git_clone_repos_by_url([next_page, dest])


def git_commit_last_with_file(argv: list[str]) -> int:
	if not argv:
	return 1

	file_path = Path(argv[0])
	log_path: Path
	if len(argv) > 1 and argv[1]:
	log_path = Path(argv[1])
	else:
	log_path = tmp_user_root() / f"git_commit_last_with_file_{now_value()}.log"
	log_path.touch()
	print(f"seeking last commit with file {file_path}...")

	last_commit = argv[2] if len(argv) > 2 else ""

	while True:
	current_commit = git_current_commit([])
	if current_commit:
		with log_path.open("a") as handle:
			handle.write(current_commit + "\n")

	if file_path.exists():
		print("file yet found, going head...")
		rc = git_go_to_next_commit([])
		if rc == 1:
			print("git_next_commit returns error, retrying")
			time.sleep(3)
		last_commit = current_commit
		continue

	print(f"file no more found, going back to {last_commit}")
	if last_commit:
		git_checkout_pristine([last_commit])
	print("finish")
	return 0


def git_commits_ahead(argv: list[str]) -> int:
	current = argv[0] if argv else git_current_commit([])
	result = run(["/usr/bin/git", "log", "--oneline", "--reverse", "--ancestry-path", f"{current}..master"], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def git_config_mass_replace(argv: list[str]) -> int:
	if len(argv) < 2:
	return 1
	old, new = argv[0], argv[1]
	root = Path.cwd()
	for item in root.iterdir():
	if not item.is_dir():
		continue
	config = item / ".git" / "config"
	if not config.exists():
		continue
	text = config.read_text(errors="ignore")
	config.write_text(text.replace(old, new))
	return 0


def git_current_commit(argv: list[str]) -> str:
	result = run(["/usr/bin/git", "rev-parse", "--short", "HEAD"], capture=True)
	return result.stdout.strip()


def git_go_to_next_commit(argv: list[str]) -> int:
	current = git_current_commit([])
	print(f"current commit is {current}...")
	next_commit = git_next_commit([current])
	print(f"next commit is {next_commit}...")
	if not next_commit:
	return 1
	return git_checkout_pristine([next_commit])


def git_next_commit(argv: list[str]) -> str:
	current = argv[0] if argv else git_current_commit([])
	result = run(["/usr/bin/git", "log", "--oneline", "--reverse", "--ancestry-path", f"{current}..master"], capture=True)
	lines = [line for line in result.stdout.splitlines() if line and current not in line]
	return lines[0].split()[0] if lines else ""


def git_repo_info(argv: list[str]) -> int:
	if not argv:
	return 1
	repo = Path(argv[0])
	if not (repo / ".git").is_dir():
	return 0
	result = run(["git", "--git-dir", str(repo / ".git"), "--work-tree", str(repo), "remote"], capture=True)
	remotes = [line.strip() for line in result.stdout.splitlines() if line.strip()]
	for remote in remotes:
	url = run(["git", "--git-dir", str(repo / ".git"), "--work-tree", str(repo), "remote", "get-url", "--all", remote], capture=True).stdout.strip()
	print(f"{remote};{url};{repo}")
	return 0


def git_workspaces_backup(argv: list[str]) -> int:
	if not argv:
	print("you need pass the root path and alias for this. i.e.: git_workspaces_backup $HOME/my_workspace_root_path")
	return 1

	root_path = Path(argv[0])
	file_path = Path(last_backup_version("git-workspaces", "csv"))
	file_path.parent.mkdir(parents=True, exist_ok=True)

	if file_path.exists():
	hostname = os.environ.get("HOSTNAME", "host")
	dest = Path.home() / "sync" / 'linux' / "git-workspaces" / f"{hostname}_{now_value()}.csv"
	dest.parent.mkdir(parents=True, exist_ok=True)
	file_path.rename(dest)

	for config in root_path.rglob(".git/config"):
	repo = config.parent.parent
	with file_path.open("a") as handle:
		result = run(["git", "--git-dir", str(repo / ".git"), "--work-tree", str(repo), "remote"], capture=True)
		remotes = [line.strip() for line in result.stdout.splitlines() if line.strip()]
		for remote in remotes:
			url = run(["git", "--git-dir", str(repo / ".git"), "--work-tree", str(repo), "remote", "get-url", "--all", remote], capture=True).stdout.strip()
			handle.write(f"{remote};{url};{repo}\n")
	return 0


def git_workspaces_restore(argv: list[str]) -> int:
	file_path = Path(last_backup_version("git-workspaces", "csv"))
	if not file_path.exists():
	return 0
	for line in file_path.read_text(errors="ignore").splitlines():
	if not line.strip():
		continue
	parts = line.split(";")
	if len(parts) < 3:
		continue
	origin_name, remote_url, local_path = parts[0], parts[1], parts[2]
	if not Path(local_path).exists():
		print(f"origin_name={origin_name}")
		print(f"remote_url={remote_url}")
		print(f"local_path={local_path}")
		run(["git", "clone", remote_url, local_path])
		print("---")
	return 0
