from __future__ import annotations

import os
import re
import time
from pathlib import Path

from pyfunctions.common import dotfiles_root, last_backup_version, run
from pyfunctions.zsh import now_value, progress_bar


def dns_local_setup(argv: list[str]) -> int:
	script = dotfiles_root() / "bash" / "scripts" / "dns_local_setup" / "dns_local_setup.sh"
	env = os.environ.copy()
	env.update({"DOMAIN": "local", "CONTAINER_NAME": "devdns", "custom_fallback_dns": "1.1.1.1"})
	return run(["bash", str(script)], env=env).returncode


def dns_systemd_resolved_stop(argv: list[str]) -> int:
	result = run(["sudo", "systemctl", "status", "systemd-resolved"], capture=True)
	if "Active: active" in result.stdout:
	run(["sudo", "systemctl", "stop", "systemd-resolved"])
	run(["sudo", "systemctl", "disable", "systemd-resolved"])
	else:
	print("systemd-resolved isn't active")
	return 0


def ip_host_over_wsl_nat(argv: list[str]) -> int:
	result = run(["ip", "route", "show"], capture=True)
	for line in result.stdout.splitlines():
	if "default" in line.lower():
		parts = line.split()
		if len(parts) >= 3:
			print(parts[2])
	return 0


def net_traffic_summary(argv: list[str]) -> int:
	interfaces = argv
	if not interfaces:
	result = run(["ifconfig", "-s"], capture=True)
	lines = [line for line in result.stdout.splitlines() if line and not line.startswith("Iface")]
	interfaces = [line.split()[0] for line in lines if line.split()]

	dev_lines = Path("/proc/net/dev").read_text(errors="ignore").splitlines()
	for iface in interfaces:
	print(f"{iface}:")
	line = next((l for l in dev_lines if f"{iface}:" in l), "")
	if not line:
		print("---")
		continue
	parts = line.split()
	if len(parts) >= 10:
		rx = float(parts[1]) / 1024 / 1024
		tx = float(parts[9]) / 1024 / 1024
		total = rx + tx
		print(f"RX: {rx} MiB\nTX: {tx} MiB\nTotal: {total} MiB")
	print("---")
	return 0


def network_reset_iptables(argv: list[str]) -> int:
	cmds = ["ip6tables", "iptables"]
	print(f"running for {' '.join(cmds)}")

	for cmd in cmds:
	print(f"running {cmd}...")
	run(["sudo", cmd, "-F"])
	run(["sudo", cmd, "-F", "FORWARD"])
	run(["sudo", cmd, "-F", "INPUT"])
	run(["sudo", cmd, "-F", "OUTPUT"])
	run(["sudo", cmd, "-P", "FORWARD", "ACCEPT"])
	run(["sudo", cmd, "-P", "INPUT", "ACCEPT"])
	run(["sudo", cmd, "-P", "OUTPUT", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-F"])
	run(["sudo", cmd, "-t", "mangle", "-P", "FORWARD", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-P", "INPUT", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-P", "OUTPUT", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-P", "POSTROUTING", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-P", "PREROUTING", "ACCEPT"])
	run(["sudo", cmd, "-t", "mangle", "-X"])
	run(["sudo", cmd, "-t", "nat", "-F"])
	run(["sudo", cmd, "-t", "nat", "-P", "OUTPUT", "ACCEPT"])
	run(["sudo", cmd, "-t", "nat", "-P", "POSTROUTING", "ACCEPT"])
	run(["sudo", cmd, "-t", "nat", "-P", "PREROUTING", "ACCEPT"])
	run(["sudo", cmd, "-t", "nat", "-X"])
	run(["sudo", cmd, "-X"])
	print(f"finish {cmd}")

	run(["sudo", "ufw", "--force", "reset"])
	run(["sudo", "ufw", "--force", "enable"])

	print("restoring rules")
	run(["bash", str(Path.home() / "sync/linux/ufw-custom.txt")])
	print("")
	run(["sudo", "ufw", "--force", "reload"])
	run(["sudo", "ufw", "status", "numbered"])
	return 0


def networks_etup_tunnel(argv: list[str]) -> int:
	time.sleep(15)
	return vpn_add_routes([])


def _vpn_get_ips_list(host: str) -> list[str]:
	result = run(["nslookup", host], capture=True)
	ips: list[str] = []
	found = False
	for line in result.stdout.splitlines():
	if "Non-authoritative answer" in line:
		found = True
		continue
	if found and "Address:" in line:
		ip = line.split()[-1]
		if ip not in ips:
			ips.append(ip)
	if not ips:
	for line in result.stdout.splitlines():
		if line.strip().startswith("Address:"):
			ip = line.split()[-1]
			if ip not in ips:
				ips.append(ip)
	return ips


def vpn_get_ips(argv: list[str]) -> int:
	if not argv:
	return 1
	ips = _vpn_get_ips_list(argv[0])
	if ips:
	print("\n".join(ips))
	return 0


def vpn_ip_subnet(argv: list[str]) -> int:
	if not argv:
	return 1
	parts = argv[0].split(".")
	if len(parts) < 3:
	return 1
	print(".".join(parts[:3]) + ".0/24")
	return 0


def vpn_ip_route_add(argv: list[str]) -> int:
	if len(argv) < 2:
	return 1
	source_net = _vpn_ip_subnet_value(argv[0])
	if not source_net:
	return 1
	run(["sudo", "ip", "route", "add", source_net, "via", argv[1]], check=False)
	return 0


def _vpn_ip_subnet_value(ip: str) -> str:
	parts = ip.split(".")
	if len(parts) < 3:
	return ""
	return ".".join(parts[:3]) + ".0/24"


def vpn_ip(argv: list[str]) -> int:
	result = run(["ip", "-o", "addr", "show", "up", "type", "ppp"], capture=True)
	for line in result.stdout.splitlines():
	parts = line.split()
	if len(parts) >= 4:
		print(parts[3])
	return 0


def _vpn_ip_value() -> str:
	result = run(["ip", "-o", "addr", "show", "up", "type", "ppp"], capture=True)
	for line in result.stdout.splitlines():
	parts = line.split()
	if len(parts) >= 4:
		return parts[3]
	return ""


def vpn_add_route(argv: list[str]) -> int:
	if not argv:
	return 1
	host = argv[0]
	local_vpn_ip = argv[1] if len(argv) > 1 else _vpn_ip_value()
	rc = 0
	for ip in _vpn_get_ips_list(host):
	rc = vpn_ip_route_add([ip, local_vpn_ip])
	return rc


def vpn_add_routes(argv: list[str]) -> int:
	file_path = argv[0] if argv else last_backup_version("vpn-routes", "csv")
	if not file_path:
	print("no vpn-routes file found")
	return 0
	new_file = re.sub(r"[0-9]+", now_value(), str(file_path))
	total = len(Path(file_path).read_text(errors="ignore").splitlines())

	print(f"\U0001F6E1\uFE0F adding my routes from {file_path} to VPN ({total})")

	local_vpn_ip = argv[1] if len(argv) > 1 else _vpn_ip_value()
	if not local_vpn_ip:
	print("VPN IP not found")
	return 0

	count = 0
	run(["sudo", "echo", "you give root permission"], check=False)

	new_file_path = Path(new_file)
	new_file_path.parent.mkdir(parents=True, exist_ok=True)

	for line in Path(file_path).read_text(errors="ignore").splitlines():
	count += 1
	parts = line.split(";")
	host = parts[0] if parts else ""
	up_at = parts[1] if len(parts) > 1 else ""
	down_at = parts[2] if len(parts) > 2 else ""

	if down_at:
		with new_file_path.open("a") as handle:
			handle.write(line + "\n")
		continue

	rc = vpn_add_route([host])
	if rc == 0:
		entry = f"{host};{now_value()};"
	else:
		entry = f"{host};{up_at};{now_value()}"
	with new_file_path.open("a") as handle:
		handle.write(entry + "\n")

	progress_bar([str(count), str(total), host])
	return 0
