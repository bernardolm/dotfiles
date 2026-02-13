from __future__ import annotations

from pathlib import Path

from pyfunctions.common import remove_paths, run, tmp_user_root


def apt_server_pristine(argv: list[str]) -> int:
	patterns = [
	"*desktop*",
	"*extra*",
	"*fonts-tibetan*",
	"*gnome*",
	"*gtk*",
	"*icon*",
	"*mate*",
	"*office*",
	"*theme*",
	"*x-server*",
	"*x11*",
	"*X11*",
	"*xorg*",
	"*xserver*",
	]
	run(["sudo", "apt", "purge", "--yes", *patterns])
	run(["sudo", "apt", "autoremove", "--purge", "--yes"])
	return run(["sudo", "apt", "install", "--yes", "ubuntu-server", "ubuntu-server-minimal"]).returncode


def audio_reset(argv: list[str]) -> int:
	run(["sudo", "killall", "pulseaudio"], check=False)
	home = Path.home()
	remove_paths(home.glob(".config/pulse/*"))
	remove_paths(home.glob(".pulse*"))
	return run(["pulseaudio", "--dump-conf", "--dump-modules", "--dump-resample-methods", "--cleanup-shm", "--start", "-D"]).returncode


def snap_clean(argv: list[str]) -> int:
	result = run(["snap", "list", "--all"], capture=True)
	for line in result.stdout.splitlines():
	if "disabled" not in line:
		continue
	parts = line.split()
	if len(parts) < 3:
		continue
	snap_name = parts[0]
	revision = parts[2]
	run(["sudo", "snap", "remove", snap_name, f"--revision={revision}"])
	return 0


def autoclean(argv: list[str]) -> int:
	run(["sudo", "apt", "autoremove", "--purge", "--yes"])
	run(["sudo", "apt", "clean", "all"])

	run(["sudo", "journalctl", "--rotate"])
	run(["sudo", "journalctl", "--vacuum-size=5M"])

	run(["sudo", "rm", "-rf", "/var/lib/apt/lists/*"])
	run(["sudo", "rm", "-rf", "/var/log/*.gz"])
	run(["sudo", "rm", "-rf", "/var/log/*.log"])

	if run(["snap", "model"], check=False).returncode == 0:
	snap_clean([])

	if run(["docker", "ps"], check=False).returncode == 0:
	from pyfunctions import docker

	docker.docker_clean([])

	home = Path.home()
	remove_paths(home.glob(".cache/*"))
	remove_paths((home / "gopath/pkg/mod/cache").glob("*"))
	remove_paths(tmp_user_root().glob("*"))
	return 0
