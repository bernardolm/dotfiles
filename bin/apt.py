from __future__ import annotations

from pathlib import Path
import re

from logger import log_debug, log_error, log_finish, log_info, log_start
from pyfunctions.common import run, tmp_user_root


def _absent_pub_keys() -> list[str]:
	result = run(["sudo", "apt-get", "update"], capture=True)
	combined = (result.stdout or "") + (result.stderr or "")
	keys = sorted(set(re.findall(r"NO_PUBKEY\s(\w{16})", combined)))
	return keys


def apt_list_absent_pub_key(argv: list[str]) -> int:
	tmp = tmp_user_root()
	tmp.mkdir(parents=True, exist_ok=True)
	out_file = tmp / "apt_list_absent_pub_key.txt"
	keys = _absent_pub_keys()
	out_file.write_text("\n".join(keys))
	if keys:
		print("\n".join(keys))
	return 0


def _apt_list_installed(pattern: str) -> list[str]:
	result = run(["apt", "list", "--installed", f"*{pattern}*"], capture=True)
	lines = result.stdout.splitlines()
	packages = []
	for line in lines[1:]:
		if not line.strip():
			continue
		packages.append(line.split("/")[0])
	return packages


def apt_list_installed(argv: list[str]) -> int:
	pattern = argv[0] if argv else ""
	packages = _apt_list_installed(pattern)
	if packages:
		print("\n".join(packages))
	return 0


def apt_search_installed(argv: list[str]) -> int:
	return apt_list_installed(argv)


def _package_count(paths: list[Path]) -> int:
	packages: set[str] = set()
	for path in paths:
		try:
			for line in path.read_text(errors="ignore").splitlines():
				if line.startswith("Package:"):
					parts = line.split(":", 1)
					if len(parts) == 2:
						packages.add(parts[1].strip())
		except OSError:
			continue

	count = 0
	for package in sorted(packages):
		res = run(["dpkg", "-l", package], capture=True)
		if any(line.startswith("ii") for line in res.stdout.splitlines()):
			count += 1
	return count


def apt_ppa_check(argv: list[str]) -> int:
	list_dir = Path("/etc/apt/sources.list.d")
	for source in sorted(list_dir.glob("*.list")):
		for raw in source.read_text(errors="ignore").splitlines():
			line = raw.strip()
			if not line.startswith("deb "):
				continue

			entry = line[4:].split("#", 1)[0].strip()
			if not entry:
				continue

			print(f"ENTRY: {entry}")
			parts = entry.split("/")
			host = parts[2] if len(parts) > 2 else ""

			if host == "ppa.launchpad.net":
				user = parts[3] if len(parts) > 3 else ""
				ppa = parts[4] if len(parts) > 4 else ""
				paths = list(Path("/var/lib/apt/lists").glob(f"*{user}*{ppa}*Packages"))
				count = _package_count(paths)
				print(f"PPA: ppa:{user}/{ppa}")
				print(f"FILENAME: {source}")
				print(f"{count} package(s) installed")
				print("")
			else:
				user = parts[2] if len(parts) > 2 else ""
				ppa = parts[3] if len(parts) > 3 else ""
				paths = list(Path("/var/lib/apt/lists").glob(f"*{user}*Packages"))
				count = _package_count(paths)
				print(f"REPOSITORY: {user}/{ppa}")
				print(f"FILENAME: {source}")
				print(f"{count} package(s) installed")
				print("")
	return 0


def apt_recovery_pub_keys(argv: list[str]) -> int:
	log_start(["recovering apt pub keys"])
	log_info(["individual pub keys"])

	file_path = Path("/etc/apt/trusted.gpg.d/1password.gpg")
	if not file_path.exists():
		log_info(["1password pub key will be recovered"])
		curl_result = run(
			["curl", "-fsSL", "https://downloads.1password.com/linux/keys/1password.asc"],
			capture=True,
		)
		run(
			["sudo", "gpg", "--yes", "--dearmor", "--output",
				str(file_path)],
			input_data=curl_result.stdout,
		)
		run(["sudo", "/bin/rm", "-f", "/etc/apt/sources.list.d/1password.list"])
		run(
			["sudo", "tee", "/etc/apt/sources.list.d/1password.list"],
			input_data=("deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/1password.gpg] "
									"https://downloads.1password.com/linux/debian/amd64 stable main"),
		)
		run(["sudo", "mkdir", "-p", "/etc/debsig/policies/AC2D62742012EA22"])
		pol = run(
			["curl", "-fsSL", "https://downloads.1password.com/linux/debian/debsig/1password.pol"],
			capture=True,
		).stdout
		run(
			["sudo", "tee", "/etc/debsig/policies/AC2D62742012EA22/1password.pol"],
			input_data=pol,
		)
		log_info(["1password recovered"])
	else:
		log_info(["1password OK"])

	file_path = Path("/etc/apt/trusted.gpg.d/docker.gpg")
	if not file_path.exists():
		log_info(["docker pub key will be recovered"])
		curl_result = run(["curl", "-fsSL", "https://download.docker.com/linux/ubuntu/gpg"],
											capture=True)
		run(
			["sudo", "gpg", "--yes", "--dearmor", "--output",
				str(file_path)],
			input_data=curl_result.stdout,
		)
		log_info(["docker recovered"])
	else:
		log_info(["docker OK"])

	file_path = Path("/etc/apt/trusted.gpg.d/cloud.google.gpg")
	if not file_path.exists():
		log_info(["google cloud pub key will be recovered"])
		curl_result = run(
			["curl", "-fsSL", "https://packages.cloud.google.com/apt/doc/apt-key.gpg"],
			capture=True,
		)
		run(
			["sudo", "gpg", "--yes", "--dearmor", "--output",
				str(file_path)],
			input_data=curl_result.stdout,
		)
		log_info(["google cloud recovered"])
	else:
		log_info(["google cloud OK"])

	servers = [
		"keyserver.ubuntu.com",
		"keys.openpgp.org",
		"keys.gnupg.net",
		"pgp.mit.edu",
	]

	if Path("/etc/apt/trusted.gpg").exists():
		run(["sudo", "/bin/rm", "-f", "/etc/apt/trusted.gpg"])

	log_info(["anothers pub keys"])

	for key in _absent_pub_keys():
		log_debug([f"pub key {key}"])

		for server in servers:
			log_debug([f"trying recover {key} from {server}"])
			result = run(
				["sudo", "apt-key", "adv", "--keyserver", server, "--recv-keys", key],
				capture=True,
			)
			if result.returncode == 0:
				break
			log_error([f"failed to {key} from {server}"])

		export_result = run(["sudo", "apt-key", "export", key], capture=True)
		run(
			[
				"sudo",
				"gpg",
				"--batch",
				"--yes",
				"--dearmour",
				"-o",
				f"/etc/apt/trusted.gpg.d/{key}.gpg",
			],
			input_data=export_result.stdout,
		)
		log_info([f"{key} OK"])

	log_finish(["recovering apt pub keys"])
	return 0
