from __future__ import annotations

import json
import os
import time
from pathlib import Path

from pyfunctions.common import remove_paths, run, which


def _docker_cmd() -> str:
	return os.environ.get("DOCKER", "docker")


def docker_install_check(argv: list[str]) -> int:
	return 0 if which(_docker_cmd()) else 1


def docker_running_check(argv: list[str]) -> int:
	result = run([_docker_cmd(), "ps"], check=False)
	return 0 if result.returncode == 0 else 1


def docker_run(argv: list[str]) -> int:
	return run([_docker_cmd(), "run", *argv]).returncode


def docker_exec_interative(argv: list[str]) -> int:
	return run([_docker_cmd(), "exec", "-it", *argv]).returncode


def docker_container_stop(argv: list[str]) -> int:
	return run([_docker_cmd(), "stop", *argv], check=False).returncode


def docker_container_remove(argv: list[str]) -> int:
	docker_container_stop(argv)
	return run([_docker_cmd(), "rm", *argv]).returncode


def docker_container_pid(argv: list[str]) -> int:
	result = run([_docker_cmd(), "inspect", "--format", "{{ .State.Pid }}", *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_container_ip(argv: list[str]) -> int:
	result = run([_docker_cmd(), "inspect", "-f", "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}", *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_container_inspect(argv: list[str]) -> int:
	fmt = "{{range .Mounts}}{{.Type}}:{{.Source}}:{{.Destination}}{{println}}{{ end }}"
	result = run([_docker_cmd(), "container", "inspect", "-f", fmt, *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_containers_list(argv: list[str]) -> int:
	result = run([_docker_cmd(), "ps", "-aq"], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_containers_list_detailed(argv: list[str]) -> int:
	fmt = "table {{.Names}}\t{{.Ports}}\t{{.Image}}\t{{.Status}}"
	result = run([_docker_cmd(), "ps", "--all", "--format", fmt, *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_containers_stop(argv: list[str]) -> int:
	print("stopping docker containers")
	if docker_install_check([]) != 0:
	return 0
	result = run([_docker_cmd(), "ps", "-aq"], capture=True)
	for cid in result.stdout.splitlines():
	if cid.strip():
		print(f"stopping {cid}")
		docker_container_stop([cid])
	return 0


def docker_containers_sanitize(argv: list[str]) -> int:
	print("removing docker containers")
	if docker_install_check([]) != 0:
	return 0
	result = run([_docker_cmd(), "ps", "-a", "-f", "status=exited", "-f", "status=created", "-q"], capture=True)
	ids = [line for line in result.stdout.splitlines() if line.strip()]
	if ids:
	run([_docker_cmd(), "rm", *ids], check=False)
	return 0


def docker_images_list(argv: list[str]) -> int:
	result = run([_docker_cmd(), "images", "-aq", *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_images_list_detailed(argv: list[str]) -> int:
	result = run([_docker_cmd(), "images", "-a", *argv], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_images_dangling(argv: list[str]) -> int:
	result = run([_docker_cmd(), "images", "-f", "dangling=true", "-q"], capture=True)
	if result.stdout:
	print(result.stdout.strip())
	return result.returncode


def docker_image_remove(argv: list[str]) -> int:
	return run([_docker_cmd(), "rmi", *argv], check=False).returncode


def docker_images_dangling_sanitize(argv: list[str]) -> int:
	print("removing dangling (untagged, '<none>') docker images")
	if docker_install_check([]) != 0:
	return 0
	result = run([_docker_cmd(), "images", "-f", "dangling=true", "-q"], capture=True)
	for image_id in result.stdout.splitlines():
	if image_id.strip():
		print(f"removing {image_id}")
		docker_image_remove([image_id])
	return 0


def docker_images_sanitize(argv: list[str]) -> int:
	if docker_install_check([]) != 0:
	return 0
	print("removing docker images")
	result = run([_docker_cmd(), "images", "-aq"], capture=True)
	for image_id in result.stdout.splitlines():
	if image_id.strip():
		print(f"removing {image_id}")
		docker_image_remove([image_id])
	return 0


def docker_clean(argv: list[str]) -> int:
	result = run([_docker_cmd(), "ps", "-a", "-q"], capture=True)
	ids = [line for line in result.stdout.splitlines() if line.strip()]
	if ids:
	run([_docker_cmd(), "stop", *ids], check=False)
	run([_docker_cmd(), "rm", *ids], check=False)
	run([_docker_cmd(), "container", "prune", "-f"], check=False)

	images = run([_docker_cmd(), "images", "-q"], capture=True).stdout.splitlines()
	if images:
	run([_docker_cmd(), "rmi", *images], check=False)
	run([_docker_cmd(), "image", "prune", "-f"], check=False)
	run([_docker_cmd(), "system", "prune", "-f"], check=False)
	return 0


def docker_logs_sanitize(argv: list[str]) -> int:
	print("removing docker logs")
	if docker_install_check([]) != 0:
	return 0
	result = run([_docker_cmd(), "ps", "-aq"], capture=True)
	for cid in result.stdout.splitlines():
	if not cid.strip():
		continue
	print(f"catching {cid} log path")
	log_path = run([_docker_cmd(), "inspect", "--format={{.LogPath}}", cid], capture=True).stdout.strip()
	if not log_path:
		continue
	print(f"container {cid} log file in {log_path}, truncating")
	run(["sudo", "truncate", "-s", "0", log_path], check=False)
	print(f"done to container {cid}")
	return 0


def docker_content_sanitize(argv: list[str]) -> int:
	print("removing docker content")
	if docker_install_check([]) != 0:
	return 0
	docker_containers_stop([])
	docker_containers_sanitize([])
	docker_images_dangling_sanitize([])
	docker_images_sanitize([])
	return 0


def docker_network_ip(argv: list[str]) -> int:
	interface = argv[0] if argv else "docker0"
	result = run(["ip", "-j", "addr", "show", interface], capture=True)
	if result.returncode != 0:
	return result.returncode
	try:
	data = json.loads(result.stdout)
	except json.JSONDecodeError:
	return 1
	for item in data:
	for addr in item.get("addr_info", []):
		if addr.get("family") != "inet":
			continue
		label = addr.get("label") or item.get("ifname")
		if label == "docker0":
			local_ip = addr.get("local", "")
			if local_ip:
				print(local_ip)
			return 0
	return 0


def docker_local_ip_sanitize(argv: list[str]) -> int:
	print("reseting docker network config")
	result = run(["ip", "-j", "addr", "show", "docker0"], capture=True)
	try:
	data = json.loads(result.stdout)
	except json.JSONDecodeError:
	data = []
	current_ip = ""
	for item in data:
	for addr in item.get("addr_info", []):
		if addr.get("family") == "inet":
			current_ip = addr.get("local", "")
			break
	if current_ip:
	print(f"docker0 network found in IP {current_ip}")
	run(["sudo", "ip", "addr", "del", "dev", "docker0", f"{current_ip}/24"], check=False)
	run(["sudo", "ip", "link", "delete", "docker0"], check=False)
	return 0


def docker_install_config_files_sanitize(argv: list[str]) -> int:
	print("removing docker install files")
	remove_paths([Path.home() / ".docker"])
	run(["sudo", "/bin/rm", "-rf", "/etc/apparmor.d/docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/etc/docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/etc/docker/daemon.json"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/etc/NetworkManager/conf.d/01_docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/etc/NetworkManager/dnsmasq.d/01_docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/usr/share/code/resources/app/extensions/docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/var/lib/docker"], check=False)
	run(["sudo", "/bin/rm", "-rf", "/var/run/docker.sock"], check=False)
	return 0


def docker_daemon_config_reset(argv: list[str]) -> int:
	print("starting docker daemon json sanitize...")

	if run(["ifconfig", "docker0"], check=False).returncode == 0:
	run(["ifconfig", "docker0"], check=False)
	run(["sudo", "ifconfig", "docker0", "down"], check=False)

	service_file = Path("/lib/systemd/system/docker.service")
	if not service_file.exists():
	print("docker service not found")
	return 0

	print("docker service active? 1")
	run(["sudo", "systemctl", "stop", "docker"], check=False)

	content = service_file.read_text(errors="ignore")
	if "StartLimitBurst=3" in content:
	print("changing docker restart limit")
	new_content = content.replace("StartLimitBurst=3", "StartLimitBurst=99")
	run(["sudo", "tee", str(service_file)], input_data=new_content)
	run(["sudo", "systemctl", "daemon-reload"], check=False)

	print("recreating docker daemon json")
	run(["sudo", "ip", "link", "delete", "docker0"], check=False)

	daemon_json = '{"debug":true,"bip":"172.17.0.1/24","dns":["1.1.1.1","8.8.8.8"]}'
	run(["sudo", "tee", "/etc/docker/daemon.json"], input_data=daemon_json)
	print(daemon_json)

	run(["sudo", "systemctl", "restart", "docker.service"], check=False)
	run(["sudo", "systemctl", "status", "docker.service"], check=False)

	if run(["ifconfig", "docker0"], check=False).returncode == 0:
	run(["ifconfig", "docker0"], check=False)
	run(["sudo", "ifconfig", "docker0", "up"], check=False)

	print("bye!")
	return 0


def docker_install(argv: list[str]) -> int:
	print("installing docker")
	if docker_install_check([]) != 0:
	print("installing docker ubuntu package")
	print("\033[0;36m")
	run(["sudo", "apt-get", "install", "--yes", "docker-ce", "docker-ce-cli", "containerd.io", "docker-compose"], check=False)
	time.sleep(1)
	run(["sudo", "apt-get", "install", "-f"], check=False)
	time.sleep(1)
	print("\033[0m")

	docker_dir = Path.home() / ".docker"
	if docker_dir.exists():
	user = os.environ.get("USER", "")
	run(["sudo", "chown", f"{user}:{user}", str(docker_dir), "-R"], check=False)
	run(["sudo", "chmod", "g+rwx", str(docker_dir), "-R"], check=False)

	if "docker" not in Path("/etc/group").read_text(errors="ignore"):
	run(["sudo", "groupadd", "docker"], check=False)
	run(["newgrp", "docker"], check=False)

	user = os.environ.get("USER", "")
	group_check = run(["getent", "group", "docker"], capture=True)
	if user and user not in group_check.stdout:
	run(["sudo", "usermod", "-aG", "docker", user], check=False)

	run(["sudo", "sysctl", "-w", "vm.max_map_count=262144"], check=False)
	sysctl_conf = Path("/etc/sysctl.conf")
	if sysctl_conf.exists() and "max_map_count" not in sysctl_conf.read_text(errors="ignore"):
	run(["sudo", "tee", "-a", str(sysctl_conf)], input_data="\nvm.max_map_count = 262144")

	run(["sudo", "systemctl", "enable", "docker"], check=False)
	run(["sudo", "systemctl", "restart", "docker"], check=False)
	return 0


def docker_install_sanitize(argv: list[str]) -> int:
	print("removing docker installation")

	if docker_running_check([]) == 0:
	print("docker is running")
	docker_content_sanitize([])
	run([_docker_cmd(), "system", "prune", "--all", "--volumes", "--force"], check=False)
	run(["sudo", "systemctl", "stop", "docker.socket"], check=False)
	run(["sudo", "systemctl", "stop", "docker.service"], check=False)

	while docker_running_check([]) == 0:
		print("waiting docker be stopped...")
		time.sleep(1)

	if not argv or argv[0] != "no-purge":
	print("finding docker installation...")
	if docker_install_check([]) == 0:
		print("purging existent docker ubuntu package")
		print("\033[0;36m")
		run(["sudo", "apt-get", "purge", "^docker", "containerd", "runc", "--yes"], check=False)
		run(["sudo", "apt-get", "autoremove", "--purge", "--yes"], check=False)
		print("\033[0m")
	else:
		print("no docker install found")

	docker_install_config_files_sanitize([])
	docker_local_ip_sanitize([])
	return 0


def docker_install_reset(argv: list[str]) -> int:
	print("reseting docker")
	docker_install_sanitize([])
	docker_install([])
	if which("install_dockerdns"):
	run(["install_dockerdns"], check=False)
	return 0


def docker_give_me_back_my(argv: list[str]) -> int:
	print("recovering docker app control")
	if docker_install_check([]) != 0:
	return 0
	result = run([_docker_cmd(), "ps", "-aq"], capture=True)
	for cid in result.stdout.splitlines():
	if cid.strip():
		run([_docker_cmd(), "update", "--restart=no", cid], check=False)
		docker_container_stop([cid])
	return 0
