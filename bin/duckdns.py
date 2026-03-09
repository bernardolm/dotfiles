from __future__ import annotations

import os

from logger import log_error, log_info, log_warn
from pyfunctions.common import run


def duckdns_update(argv: list[str]) -> int:
	if len(argv) < 2:
		return 1
	domain, ip4 = argv[0], argv[1]
	ip6 = argv[2] if len(argv) > 2 else ""
	token = os.environ.get("DUCKDNS_TOKEN", "")

	duckdns_url = "https://www.duckdns.org/update?verbose=true"
	duckdns_url += f"&ip={ip4}"
	duckdns_url += f"&ipv6={ip6}"
	duckdns_url += f"&token={token}"
	duckdns_url += f"&domains={domain}"

	msg = f"updating duckdns domain {domain}.duckdns.org with {ip4}"

	result = run(["curl", "-L", "--silent", "--insecure", "--output", "/dev/null", duckdns_url],
								check=False)
	if result.returncode == 0:
		log_info([msg])
	else:
		log_error([msg])
	return result.returncode


def duckdns_update_host(argv: list[str]) -> int:
	domain = os.environ.get("GITHUB_USER", "") + "--" + os.environ.get("HOSTNAME", "")
	ip_current = os.environ.get("IP_CURRENT", "")
	return duckdns_update([domain, ip_current, ""])


def duckdns_update_public(argv: list[str]) -> int:
	if os.environ.get("MY_PLACE") == "work":
		log_warn([
			f"at {os.environ.get('MY_PLACE')} does not need to update '{os.environ.get('DUCKDNS_DOMAIN')}'"
		])
		return 0
	domain = os.environ.get("DUCKDNS_DOMAIN", "")
	ip_public = os.environ.get("IP_PUBLIC", "")
	return duckdns_update([domain, ip_public, ""])


def duckdns_update_all(argv: list[str]) -> int:
	duckdns_update_host([])
	duckdns_update_public([])
	return 0
