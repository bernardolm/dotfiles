from __future__ import annotations

from pathlib import Path

from pyfunctions.common import run


def ufw_backup(argv: list[str]) -> int:
	result = run(["sudo", "ufw", "show", "added"], capture=True)
	lines = result.stdout.splitlines()[1:]
	out_file = Path.home() / "sync/linux/ufw/rules.sh"
	out_file.parent.mkdir(parents=True, exist_ok=True)
	out_file.write_text("\n".join(lines))
	return 0


def ufw_start(argv: list[str]) -> int:
	ufw_conf = Path("/etc/default/ufw")
	content = ufw_conf.read_text(errors="ignore") if ufw_conf.exists() else ""
	if "IPV6=yes" not in content:
	block = (
		"\n\n# Set to yes to apply rules to support IPv6 (no means only IPv6 on loopback\n"
		"# accepted). You will need to 'disable' and then 'enable' the firewall for\n"
		"# the changes to take affect.\nIPV6=yes"
	)
	run(["sudo", "tee", "-a", str(ufw_conf)], input_data=block)
	print("add ipv6!")
	for idx, line in enumerate((content + block).splitlines(), start=1):
		if "IPV6" in line:
			print(f"{idx}:{line}")
	else:
	print("ipv6 is already enabled")

	rules_glob = [
	"/etc/ufw/after.rules.*",
	"/etc/ufw/after6.rules.*",
	"/etc/ufw/before.rules.*",
	"/etc/ufw/before6.rules.*",
	"/etc/ufw/user.rules.*",
	"/etc/ufw/user6.rules.*",
	]
	for pattern in rules_glob:
	run(["sudo", "rm", "-rf", pattern], check=False)

	run(["ufw", "-f", "reset"])
	run(["ufw", "-f", "enable"])
	run(["ufw", "default", "deny", "incoming"])
	run(["ufw", "default", "allow", "outgoing"])

	rules_file = Path.home() / "sync/linux/ufw/rules.sh"
	if rules_file.exists():
	run(["/bin/sh", str(rules_file)])

	run(["ufw", "reload"])
	run(["ufw", "status", "verbose"])
	return 0
