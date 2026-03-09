from __future__ import annotations

import os
from pathlib import Path
import re

from logger import log_debug
from pyfunctions.common import run


def ssh_agent_kill(argv: list[str]) -> int:
	log_debug(["killing ssh agent and cleaning vestigies..."])
	run(["ssh-agent", "-k"], check=False)
	output_script = os.environ.get("SSH_AGENT_OUTPUT_SCRIPT")
	if output_script and Path(output_script).exists():
		Path(output_script).unlink()
	log_debug(["ssh agent was killed and vestigies deleted"])
	return 0


def ssh_agents_running(argv: list[str]) -> int:
	result = run(["pgrep", "-x", "ssh-agent"], capture=True)
	count = len(result.stdout.split()) if result.returncode == 0 else 0
	print(str(count))
	return 0


def ssh_agent_running(argv: list[str]) -> int:
	result = run(["pgrep", "-x", "ssh-agent"], capture=True)
	count = len(result.stdout.split()) if result.returncode == 0 else 0
	print("1" if count > 0 else "0")
	return 0


def ssh_agent_loaded_keys(argv: list[str]) -> int:
	result = run(["pgrep", "-x", "ssh-agent"], capture=True)
	count = len(result.stdout.split()) if result.returncode == 0 else 0
	if count == 1:
		keys = run(["ssh-add", "-L"], capture=True).stdout.splitlines()
		print(str(len(keys)))
	return 0


def ssh_agent_my_key_is_loaded(argv: list[str]) -> int:
	result = run(["pgrep", "-x", "ssh-agent"], capture=True)
	count = len(result.stdout.split()) if result.returncode == 0 else 0
	if count > 0:
		pubkey_path = Path.home() / ".ssh/id_ed25519.pub"
		if not pubkey_path.exists():
			return 1
		key = pubkey_path.read_text(errors="ignore").split()
		if len(key) < 2:
			return 1
		fingerprint = key[1]
		listed = run(["ssh-add", "-L"], capture=True).stdout
		return 0 if fingerprint in listed else 1
	return 1


def ssh_agent_ppid(argv: list[str]) -> int:
	result = run(["pgrep", "-x", "ssh-agent"], capture=True)
	if result.returncode == 0:
		print(" ".join(result.stdout.split()))
	return 0


def ssh_agent_start(argv: list[str]) -> int:
	log_debug(["starting ssh agent..."])
	result = run(["ssh-agent", "-s"], capture=True)
	output = result.stdout

	auth_match = re.search(r"SSH_AUTH_SOCK=([^;]+);", output)
	pid_match = re.search(r"SSH_AGENT_PID=([0-9]+);", output)
	if auth_match:
		os.environ["SSH_AUTH_SOCK"] = auth_match.group(1)
	if pid_match:
		os.environ["SSH_AGENT_PID"] = pid_match.group(1)

	output_script = os.environ.get("SSH_AGENT_OUTPUT_SCRIPT")
	if output_script:
		Path(output_script).write_text(output)

	log_debug(["ssh agent have been started"])
	return 0


def ssh_agent_state(argv: list[str]) -> int:
	result = run(["ssh-add", "-L"], capture=True)
	output = (result.stdout or "") + (result.stderr or "")
	state = "alive"

	if "No such file or directory" in output:
		state = "no_connection"
	elif "Connection refused" in output:
		state = "no_connection"
	elif "Could not open a connection to your authentication agent." in output:
		state = "no_connection"
	elif "The agent has no identities." in output:
		state = "empty"

	print(state)
	return 0


def ssh_envs(argv: list[str]) -> int:
	print("")
	original = os.environ.get("SHELL_DEBUG")
	os.environ["SHELL_DEBUG"] = "1"

	pub_key = os.environ.get("pub_key", "")
	log_debug([f"pub_key={pub_key}"])
	keys = run(["ssh-add", "-L"], capture=True).stdout.splitlines()
	log_debug([f"ssh_agent_loaded_keys={len(keys)}"])
	log_debug([f"SSH_AGENT_OUTPUT_SCRIPT={os.environ.get('SSH_AGENT_OUTPUT_SCRIPT', '')}"])
	log_debug([f"SSH_AGENT_PID={os.environ.get('SSH_AGENT_PID', '')}"])
	pids = run(["pgrep", "-x", "ssh-agent"], capture=True).stdout.split()
	log_debug([f"ssh_agent_ppid={' '.join(pids)}"])
	log_debug([f"ssh_agents_running={len(pids)}"])
	log_debug([f"SSH_AUTH_SOCK={os.environ.get('SSH_AUTH_SOCK', '')}"])
	log_debug([f"SSH_CONNECTION={os.environ.get('SSH_CONNECTION', '')}"])

	if original is None:
		os.environ.pop("SHELL_DEBUG", None)
	else:
		os.environ["SHELL_DEBUG"] = original
	print("")
	return 0


def ssh_fs_dpipe(argv: list[str]) -> int:
	host = os.environ.get("SSHFS_HOST_CLIENT", "")
	path_server = os.environ.get("SSHFS_PATH_SERVER", "")
	path_client = os.environ.get("SSHFS_PATH_CLIENT", "")
	if not host or not path_server or not path_client:
		return 1
	remote_cmd = (
		f"sshfs -f :{path_server} {path_client} "
		"-o allow_other,auto_unmount,follow_symlinks,NoHostAuthenticationForLocalhost=yes,reconnect,slave ; "
		f"bash ; umount {path_client} ")
	cmd = [
		"dpipe",
		"/usr/lib/openssh/sftp-server",
		"=",
		"ssh",
		"-X",
		"-t",
		host,
		remote_cmd,
	]
	return run(cmd).returncode


def ssh_route_port(argv: list[str]) -> int:
	if len(argv) < 4:
		print("sintax:\nssh_route_port port_to_route remote_ssh_user remote_ssh_host remote_ssh_port")
		return 1
	port_to_route, remote_user, remote_host, remote_port = argv[:4]
	extra = argv[4:]
	cmd = [
		"ssh", "-D", port_to_route, "-N", f"{remote_user}@{remote_host}", "-p", remote_port, *extra
	]
	print("sintax:\nssh_route_port port_to_route remote_ssh_user remote_ssh_host remote_ssh_port")
	print("\nrunning:\n" + " ".join(cmd))
	return run(cmd).returncode
