from __future__ import annotations

import os
import random
import re
import shutil
import subprocess
import time
from datetime import datetime
from pathlib import Path
from typing import Iterable

from pyfunctions.common import (
	detect_os,
	dotfiles_root,
	ensure_dir,
	is_truthy,
	remove_paths,
	run,
	run_lines,
	run_pipeline,
	which,
)


def _env(name: str, default: str = "") -> str:
	return os.environ.get(name, default)


def _bool_env(name: str) -> bool:
	return is_truthy(os.environ.get(name))


def _elapsed_time_root() -> Path:
	root = os.environ.get("ELAPSED_TIME_ROOT")
	if root:
	return Path(root)
	tmp_user = os.environ.get("TMP_USER", str(Path.home() / "sync/tmp/unknown"))
	session = os.environ.get("SESSION_ID", now_value())
	return Path(tmp_user) / "elapsed_time" / session


def color_value(name: str) -> str:
	colors = {
	"no": "\033[0m",
	"black": "\033[0;30m",
	"red": "\033[0;31m",
	"green": "\033[0;32m",
	"brown": "\033[0;33m",
	"blue": "\033[0;34m",
	"purple": "\033[0;35m",
	"cyan": "\033[0;36m",
	"light_gray": "\033[0;37m",
	"gray": "\033[1;30m",
	"rose": "\033[1;31m",
	"light_green": "\033[1;32m",
	"yellow": "\033[1;33m",
	"light_blue": "\033[1;34m",
	"light_purple": "\033[1;35m",
	"light_cyan": "\033[1;36m",
	"white": "\033[1;37m",
	"bg_purple": "\033[38;5;15m\033[48;5;129m\033[1m ",
	"bg_blue": "\033[38;5;15m\033[48;5;21m\033[1m ",
	"bg_cyan": "\033[38;5;235m\033[48;5;51m\033[1m ",
	"bg_green": "\033[38;5;235m\033[48;5;40m\033[1m ",
	"bg_grey": "\033[38;5;235m\033[48;5;253m\033[1m ",
	"bg_red": "\033[38;5;235m\033[48;5;9m\033[1m ",
	"bg_rose": "\033[38;5;15m\033[48;5;201m\033[1m ",
	"bg_white": "\033[38;5;235m\033[48;5;5m\033[1m ",
	"bg_yellow": "\033[38;5;235m\033[48;5;226m\033[1m ",
	}
	if name.startswith("x") and name[1:].isdigit():
	return f"\033[38;5;{name[1:]}m"
	return colors.get(name, "")


def color(argv: list[str]) -> int:
	if not argv:
	return 0
	print(color_value(argv[0]), end="")
	return 0


def now_value() -> str:
	now = datetime.now()
	nanos = time.time_ns() % 1_000_000_000
	return now.strftime("%Y-%m-%d_%H-%M-%S-") + f"{nanos:09d}"


def now(argv: list[str]) -> int:
	print(now_value())
	return 0


def epoch_value() -> int:
	return int(time.time() * 1000)


def epoch(argv: list[str]) -> int:
	print(epoch_value())
	return 0


def slugify_text(text: str) -> str:
	import unicodedata

	normalized = unicodedata.normalize("NFKD", text)
	ascii_text = normalized.encode("ascii", "ignore").decode("ascii")
	slug = re.sub(r"[^a-zA-Z0-9]+", "-", ascii_text).strip("-")
	return slug.lower()


def slugify(argv: list[str]) -> int:
	if not argv:
	return 0
	print(slugify_text(" ".join(argv)))
	return 0


def comment_remove(argv: list[str]) -> int:
	text = " ".join(argv)
	result = re.sub(r"^([^#]+)#.*$", r"\1", text)
	print(result)
	return 0


def file_lines_2_inline(argv: list[str]) -> int:
	if not argv:
	return 0
	path = Path(argv[0])
	if not path.exists():
	return 0
	lines = [line for line in path.read_text(errors="ignore").splitlines() if "#" not in line]
	print(" ".join(lines))
	return 0


def find_to_array(argv: list[str]) -> int:
	if not argv:
	return 0
	result = run(["find", *argv, "-print0"], capture=True)
	if result.returncode != 0:
	return result.returncode
	for item in result.stdout.split("\0"):
	if item:
		print(item)
	return 0


def contains_in_array(argv: list[str]) -> int:
	if not argv:
	print("0")
	return 0
	target = argv[0]
	array = argv[1:]
	print("1" if target in array else "0")
	return 0


def items_counter(argv: list[str]) -> int:
	if not argv:
	print("0")
	return 0
	text = argv[0]
	count = len(text.splitlines()) if text else 0
	print(str(count))
	return 0


def file_size(argv: list[str]) -> int:
	if not argv:
	return 0
	path = Path(argv[0])
	if not path.exists():
	return 0
	size = path.stat().st_size
	units = ["B", "K", "M", "G", "T", "P"]
	idx = 0
	while size >= 1024 and idx < len(units) - 1:
	size /= 1024.0
	idx += 1
	if idx == 0:
	formatted = f"{int(size)}{units[idx]}"
	else:
	formatted = f"{size:.1f}{units[idx]}"
	print(formatted)
	return 0


def files_count(argv: list[str]) -> int:
	if not argv:
	print("0")
	return 0
	path = Path(argv[0])
	if not path.exists():
	print("0")
	return 0
	count = sum(1 for _ in path.rglob("*") if _.is_file())
	print(str(count))
	return 0


def which_shell(argv: list[str]) -> int:
	shell = os.environ.get("SHELL")
	if not shell:
	result = run(["ps", "-p", str(os.getpid()), "-ocomm="], capture=True)
	shell = result.stdout.strip() if result.stdout else ""
	print(shell)
	return 0


def find_function_by_name(argv: list[str]) -> int:
	if not argv:
	return 0
	term = argv[0]
	print(f"searching functions or aliases with term: {term}")
	root = dotfiles_root()
	matches = []
	for path in root.rglob("functions"):
	if not path.is_dir():
		continue
	for file in path.iterdir():
		if file.is_file() and term in file.name:
			matches.append(file.name)
	for name in sorted(set(matches)):
	print(name)
	return 0


def memory_used(argv: list[str]) -> int:
	if not argv:
	return 1
	name = argv[0]
	if not which("smem"):
	return 1
	result = run(["smem", "-H", "-c", "name pss", "-t", "-P", f"{name}$", "-n", "-k"], capture=True)
	if result.returncode != 0:
	return result.returncode
	lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]
	mem = lines[-1] if lines else ""
	print(f"{name} is using {mem} of mem")
	return 0


def memory_used_watcher(argv: list[str]) -> int:
	if not argv:
	return 1
	cmd = ["watch", "-c", "-n1", "-x", "bash", "-c", f"smem -H -c 'name pss' -t -P '{argv[0]}$' -n -k | tail -n 1"]
	return run(cmd).returncode


def kill_by_port(argv: list[str]) -> int:
	if not argv:
	return 1
	port = argv[0]
	pids = run(["sudo", "lsof", "-t", f"-i:{port}"], capture=True)
	if pids.stdout:
	for pid in pids.stdout.split():
		run(["sudo", "kill", "-9", pid])
	return 0


def is_number(argv: list[str]) -> int:
	if not argv:
	print("0")
	return 0
	num = argv[0]
	valid = bool(re.match(r"^[+\-]?[0-9]+$", num))
	print("1" if valid else "0")
	return 0


def caller_function(argv: list[str]) -> int:
	import inspect

	stack = inspect.stack()[1:]
	parts = []
	for frame in stack:
	fname = os.path.basename(frame.filename)
	if fname.startswith("log_"):
		continue
	parts.append(fname)
	if parts:
	print(" " + " > ".join(parts), end="")
	return 0


def log_echo_value(msg: str) -> str:
	return msg


def log_echo(argv: list[str]) -> int:
	msg = " ".join(argv)
	cols = shutil.get_terminal_size((80, 20)).columns
	caller = ""
	if _bool_env("SHELL_TRACE"):
	caller = _caller_string()
	output = msg
	output_len = _strip_ansi(output)
	caller_len = _strip_ansi(caller)
	if cols >= 80 and caller:
	pad = max(cols - len(output_len) - len(caller_len), 1)
	space = " " * pad
	output = f"{output}{space}{caller}"
	print(output)
	return 0


def _strip_ansi(text: str) -> str:
	return re.sub(r"\x1b\[[0-9;]*m", "", text)


def _caller_string() -> str:
	import inspect

	frames = inspect.stack()[2:]
	parts = []
	for frame in frames:
	name = os.path.basename(frame.filename)
	if "log_" in name:
		continue
	parts.append(name)
	return " ".join(parts)


def log_info(argv: list[str]) -> int:
	return log_echo(["\U0001F4AC", f"{color_value('bg_cyan')}" + " ".join(argv) + f" {color_value('no')}"])


def log_warn(argv: list[str]) -> int:
	return log_echo(["\U0001F6A7", f"{color_value('bg_yellow')}" + " ".join(argv) + f" {color_value('no')}"])


def log_error(argv: list[str]) -> int:
	return log_echo(["\U0001F4A3", f"{color_value('bg_red')}" + " ".join(argv) + f" {color_value('no')}"])


def log_debug(argv: list[str]) -> int:
	return log_echo(["\U0001F41E", f"{color_value('bg_grey')}" + " ".join(argv) + f" {color_value('no')}"])


def log_start(argv: list[str]) -> int:
	elapsed_time_set(argv)
	if _bool_env("SHELL_DEBUG"):
	log_echo(["\U0001F6A5", "starting", " ".join(argv)])
	return 0


def log_finish(argv: list[str]) -> int:
	val = elapsed_time_get_value(argv)
	msg = f"\U0001F6A5 {argv[0] if argv else ''} {color_value('light_cyan')}was finished{color_value('no')} "
	suffix = ""
	if val:
	result = elapsed_time_value(int(val))
	if result:
		suffix = f"\U000023F1 took {result}"
	else:
	now_time = datetime.now()
	suffix = f"at {color_value('yellow')}{now_time.strftime('%H:%M')} {color_value('gray')}{now_time.strftime('%S.%f')}{color_value('no')}"
	elapsed_time_del(argv)
	if suffix:
	log_echo([msg + suffix])
	return 0


def log_env(argv: list[str]) -> int:
	if not argv:
	return 0
	key = argv[0]
	for k, v in os.environ.items():
	if k == key:
		log_echo([f"{color_value('bg_grey')}{k}={v} {color_value('no')}"])
		break
	return 0


def log_waiting(argv: list[str]) -> int:
	max_times = 10
	wait_seconds = 7
	while max_times > 0:
	time.sleep(wait_seconds)
	val = elapsed_time_get_value(argv)
	if not val:
		break
	max_times -= 1
	emoji = emoji_random_value(["\U0001F9A5", "\U0001F634", "\U0001F4A4", "\U0001F971"])
	log_echo(["  " + " ".join(argv), f"{color_value('gray')}is taking too long to load{color_value('no')}", emoji])
	return 0


def log_is_command_success(argv: list[str]) -> int:
	code = int(argv[0]) if argv else 0
	if code == 0:
	print(f"{color_value('bg_green')}\u27BF \U0001F609{color_value('no')}")
	else:
	print(f"{color_value('bg_red')}\u27BF \U0001F92C{color_value('no')}")
	return 0


def log(argv: list[str]) -> int:
	if not argv:
	return 0
	level = argv[0]
	if level in {"debug", "env"} and not _bool_env("SHELL_DEBUG"):
	return 0
	msg = argv[1:]
	if level == "info":
	return log_info(msg)
	if level == "warn":
	return log_warn(msg)
	if level == "error":
	return log_error(msg)
	if level == "debug":
	return log_debug(msg)
	if level == "env":
	return log_env(msg)
	if level == "start":
	return log_start(msg)
	if level == "finish":
	return log_finish(msg)
	return 0


def elapsed_time_set(argv: list[str]) -> int:
	key = slugify_text(" ".join(argv))
	file_path = _elapsed_time_root() / key
	ensure_dir(file_path.parent)
	file_path.write_text(str(epoch_value()))
	return 0


def elapsed_time_get_value(argv: list[str]) -> str:
	key = slugify_text(" ".join(argv))
	file_path = _elapsed_time_root() / key
	if not file_path.exists() or file_path.is_dir():
	return ""
	return file_path.read_text().strip()


def elapsed_time_get(argv: list[str]) -> int:
	value = elapsed_time_get_value(argv)
	if value:
	print(value)
	return 0


def elapsed_time_del(argv: list[str]) -> int:
	key = slugify_text(" ".join(argv))
	file_path = _elapsed_time_root() / key

	def _del() -> None:
	time.sleep(1)
	if file_path.exists() and file_path.is_file():
		file_path.unlink()

	import threading

	threading.Thread(target=_del, daemon=True).start()
	return 0


def elapsed_time_value(start_ms: int) -> str:
	d_ms = epoch_value() - start_ms
	if d_ms <= 500:
	return ""
	d_s = d_ms // 1000
	ms = d_ms % 1000
	s = d_s % 60
	m = (d_s // 60) % 60
	h = d_s // 3600
	if ms < 0:
	ms = 0
	if h > 0:
	return f"{color_value('purple')}{h}h {m}m {s}s {ms}ms{color_value('no')} \U0001FAA6"
	if m > 0:
	return f"{color_value('light_purple')}{m}m {s}s {ms}ms{color_value('no')} \U0001F976"
	if s >= 3:
	return f"{color_value('light_blue')}{s}s {ms}ms{color_value('no')} \U0001F422"
	if ms >= 2500:
	return f"{color_value('blue')}{s}s {ms}ms{color_value('no')} \U0001F914"
	if s > 0:
	return f"{color_value('cyan')}{s}s {ms}ms{color_value('no')} \U0001F6FA"
	if ms > 500:
	return f"{color_value('light_cyan')}{ms}ms{color_value('no')} \U0001F697"
	if ms > 100:
	return f"{color_value('light_green')}{ms}ms{color_value('no')} \U0001F681"
	return f"{color_value('green')}{ms}ms{color_value('no')} \U0001F680"


def elapsed_time(argv: list[str]) -> int:
	if not argv:
	return 0
	try:
	start = int(argv[0])
	except ValueError:
	return 0
	result = elapsed_time_value(start)
	if result:
	print(result)
	return 0


def elapsed_time_status(argv: list[str]) -> int:
	root = _elapsed_time_root()
	if not root.exists():
	return 0
	entries = []
	key_size = len("key")
	val_size = len("value")
	for file_path in root.iterdir():
	if file_path.is_dir():
		continue
	k = file_path.name
	v = file_path.read_text().strip()
	entries.append((k, v))
	key_size = max(key_size, len(k))
	val_size = max(val_size, len(v))
	key_format = f"{{:<{key_size}}}"
	val_format = f"{{:<{val_size}}}"
	lines = []
	lines.append(key_format.format("key") + "\t" + val_format.format("value"))
	lines.append("-" * key_size + "\t" + "-" * val_size)
	for k, v in entries:
	lines.append(key_format.format(k) + "\t" + val_format.format(v))
	print("\n".join(lines))
	return 0


def emoji_random_value(items: Iterable[str] | None = None) -> str:
	defaults = [
	"\U0001F4A9",
	"\U0001F426",
	"\U0001F680",
	"\U0001F41E",
	"\U0001F3A8",
	"\U0001F355",
	"\U0001F42D",
	"\U0001F47D",
	"\U00002615",
	"\U0001F52C",
	"\U0001F480",
	"\U0001F437",
	"\U0001F43C",
	"\U0001F436",
	"\U0001F438",
	"\U0001F427",
	"\U0001F433",
	"\U0001F354",
	"\U0001F363",
	"\U0001F37B",
	"\U0001F52E",
	"\U0001F4B0",
	"\U0001F48E",
	"\U0001F4BE",
	"\U0001F49C",
	"\U0001F36A",
	"\U0001F31E",
	"\U0001F30D",
	"\U0001F40C",
	"\U0001F413",
	"\U0001F344",
	]
	choices = list(items) if items else defaults
	return random.choice(choices) if choices else ""


def emoji_random(argv: list[str]) -> int:
	items = argv if argv else None
	print(emoji_random_value(items), end="")
	return 0


def chmod_easy(argv: list[str]) -> int:
	if len(argv) < 4:
	return 1
	mode = f"u={argv[0]},g={argv[1]},o={argv[2]}"
	return run(["chmod", mode, argv[3]]).returncode


def chrome_bookmarks_backup(argv: list[str]) -> int:
	backup_dir = Path.home() / "sync/linux/chrome/bookmarks"
	ensure_dir(backup_dir)
	base = Path.home() / ".config/google-chrome"
	if not base.exists():
	return 0
	for item in base.rglob("*Bookmarks*"):
	slug = re.sub(r"[ /.]", "_", str(item))
	dest = backup_dir / f"{slug}_{now_value()}"
	shutil.copy2(item, dest)
	return 0


def conky_kill(argv: list[str]) -> int:
	return run(["killall", "-9", "conky"], check=False).returncode


def conky_instances(argv: list[str]) -> int:
	out, _ = run_pipeline([
	["ps", "auxwf"],
	["grep", "-v", "grep"],
	["grep", "_ conky"],
	["wc", "-l"],
	])
	print(out.strip())
	return 0


def conky_start(argv: list[str]) -> int:
	return 0


def conky_restart(argv: list[str]) -> int:
	conky_kill([])
	time.sleep(1)
	conky_start([])
	return 0


def crontab_backup(argv: list[str]) -> int:
	hostname = os.environ.get("HOSTNAME", "host")
	root = Path.home() / "sync/linux/crontab"
	ensure_dir(root)
	current = root / f"{hostname}_current.txt"
	if current.exists():
	current.rename(root / f"{hostname}_{now_value()}.txt")
	result = run(["crontab", "-l"], capture=True)
	current.write_text(result.stdout)
	return 0


def db_migrate(argv: list[str]) -> int:
	if not argv:
	return 1
	image = "renatovico/simple-db-migrate"
	run(["docker", "build", "https://raw.githubusercontent.com/renatovico/simple-db-migrate-docker/master/Dockerfile", "-t", f"{image}:latest"])
	print(f"params to use in database {argv[0]}:")
	for item in argv[1:]:
	print(f"\U0001F538 {item}")
	workspace_org = os.environ.get("WORKSPACE_ORG", "")
	hud_user = os.environ.get("HUD_DB_USER", "")
	hud_pass = os.environ.get("HUD_DB_PASSWORD", "")
	cmd = [
	"docker",
	"run",
	"-it",
	"--rm",
	"--user",
	f"{os.getuid()}:{os.getgid()}",
	"--volume",
	f"{workspace_org}/banco-de-dados/migrate/{argv[0]}:/banco-de-dados",
	"--workdir=/banco-de-dados",
	image,
	"db-migrate",
	"--color",
	f"--config={argv[0]}.conf",
	f"--db-host=database_{argv[0]}.hud",
	f"--db-user={hud_user}",
	f"--db-password={hud_pass}",
	*argv[1:],
	]
	print("executing cmd:\n" + " ".join(cmd) + "\n")
	return run(cmd).returncode


def disable_accelerometter(argv: list[str]) -> int:
	if not which("xinput"):
	return 1
	out, _ = run_pipeline([
	["xinput", "--list"],
	["grep", "Touchscreen"],
	["grep", "-o", "id=[0-9]+"],
	["cut", "-d=", "-f2"],
	])
	for line in out.splitlines():
	if line.strip():
		run(["xinput", "disable", line.strip()])
	return 0


def disable_amazon_search(argv: list[str]) -> int:
	scopes = "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"
	return run(["gsettings", "set", "com.canonical.Unity.Lenses", "disabled-scopes", scopes]).returncode


def disable_tracker(argv: list[str]) -> int:
	lines = "\nHidden=true\n"
	run(["sudo", "tee", "--append", "/etc/xdg/autostart/tracker-extract.desktop"], input_data=lines)
	run(["sudo", "tee", "--append", "/etc/xdg/autostart/tracker-miner-apps.desktop"], input_data=lines)
	run(["sudo", "tee", "--append", "/etc/xdg/autostart/tracker-miner-fs.desktop"], input_data=lines)
	run(["sudo", "tee", "--append", "/etc/xdg/autostart/tracker-miner-user-guides.desktop"], input_data=lines)
	run(["sudo", "tee", "--append", "/etc/xdg/autostart/tracker-store.desktop"], input_data=lines)
	run(["gsettings", "set", "org.freedesktop.Tracker.Miner.Files", "crawling-interval", "-2"])
	run(["gsettings", "set", "org.freedesktop.Tracker.Miner.Files", "enable-monitors", "false"])
	run(["tracker", "reset", "--hard"])
	return 0


def dot_ls(argv: list[str]) -> int:
	if argv:
	return run(["dot", *argv]).returncode
	result = run(["dot", "ls-files"], capture=True)
	if result.returncode != 0:
	return result.returncode
	rows = []
	for line in result.stdout.splitlines():
	if not line.strip():
		continue
	status = run(["dot", "-c", "color.status=always", "status", line, "-s"], capture=True).stdout
	status = status.replace(line, "").strip()
	subject = run(["dot", "-c", "color.ui=always", "log", "-1", "--format=%s", "--", line], capture=True).stdout.strip()
	rows.append([status, f"/{line}", subject])
	col1 = max((len(_strip_ansi(r[0])) for r in rows), default=0)
	col2 = max((len(r[1]) for r in rows), default=0)
	for status, path, subject in rows:
	print(f"{status:<{col1}}  {path:<{col2}}  {subject}")
	return 0


def dropbox_sync(argv: list[str]) -> int:
	wait_for = 300
	run(["notify-send", "dropbox-worker", "running..."])
	run(["dropbox.py", "start"])
	time.sleep(wait_for)
	run(["dropbox.py", "stop"])
	run(["notify-send", "dropbox-worker", "finish"])
	return 0


def exa_folder_summary(argv: list[str]) -> int:
	if not which("exa"):
	return 1
	cmd = [
	"exa",
	"--blocks",
	"--classify",
	"--color-scale",
	"--color=always",
	"--group-directories-first",
	"--icons",
	"--inode",
	"--level=2",
	"--links",
	"--list-dirs",
	"--octal-permissions",
	"--tree",
	]
	result = run(cmd, capture=True)
	lines = result.stdout.splitlines()[:30]
	print("\n".join(lines))
	return result.returncode


def extract(argv: list[str]) -> int:
	if not argv:
	return 1
	path = argv[0]
	if not Path(path).is_file():
	print(f"'{path}' is not a valid file")
	return 1
	if path.endswith(".tar.bz2"):
	return run(["tar", "-jxvf", path]).returncode
	if path.endswith(".tar.gz"):
	return run(["tar", "-zxvf", path]).returncode
	if path.endswith(".bz2"):
	return run(["bunzip2", path]).returncode
	if path.endswith(".dmg"):
	return run(["hdiutil", "mount", path]).returncode
	if path.endswith(".gz"):
	return run(["gunzip", path]).returncode
	if path.endswith(".tar"):
	return run(["tar", "-xvf", path]).returncode
	if path.endswith(".tbz2"):
	return run(["tar", "-jxvf", path]).returncode
	if path.endswith(".tgz"):
	return run(["tar", "-zxvf", path]).returncode
	if path.lower().endswith(".zip"):
	return run(["unzip", path]).returncode
	if path.endswith(".pax"):
	out, code = run_pipeline([["/bin/cat", path], ["pax", "-r"]])
	if out:
		print(out)
	return code
	if path.endswith(".pax.Z"):
	out, code = run_pipeline([["uncompress", path, "--stdout"], ["pax", "-r"]])
	if out:
		print(out)
	return code
	if path.endswith(".rar"):
	return run(["unrar", "x", path]).returncode
	if path.endswith(".Z"):
	return run(["uncompress", path]).returncode
	print(f"'{path}' cannot be extracted/mounted via extract()")
	return 1


def figlet_maker(argv: list[str]) -> int:
	if not argv:
	return 1
	result = run(["figlet", argv[0]], capture=True)
	if result.returncode != 0:
	return result.returncode
	for line in result.stdout.splitlines():
	line = line.replace("^", "@printf \"\\033[33m")
	line = line.replace("`", "\\`")
	print(line + " \\n\"")
	print('@printf "\\033[0m\\n"')
	return 0


def find_text_here(argv: list[str]) -> int:
	if not argv:
	return 1
	return run(["rg", "-i", argv[0]]).returncode


def funcstack_breadcrumbs(argv: list[str]) -> int:
	import inspect

	for frame in inspect.stack()[1:]:
	print(f"> {frame.function}")
	return 0


def google_drive_sync(argv: list[str]) -> int:
	run(["notify-send", "google drive worker", "running..."])
	run(["rsync", "-au", "--delete", str(Path.home() / "sync/linux/"), str(Path.home() / "google-drive/ubuntu/")])
	for path in (Path.home() / "google-drive/ubuntu").rglob("node_modules"):
	if path.is_dir():
		shutil.rmtree(path, ignore_errors=True)
	run([
	"rclone",
	"sync",
	"--copy-links",
	"--check-first",
	"--delete-before",
	"--delete-excluded",
	"--fast-list",
	"--progress",
	"--rc",
	"--rc-enable-metrics",
	"--transfers",
	"12",
	str(Path.home() / "google-drive/ubuntu/"),
	"ubuntu:",
	])
	run(["notify-send", "google drive worker", "finish"])
	return 0


def hibernate_now(argv: list[str]) -> int:
	run(["sudo", "tee", "/sys/power/disk"], input_data="platform\n")
	run(["sudo", "tee", "/sys/power/state"], input_data="disk\n")
	run(["gnome-screensaver-command", "-l"])
	return 0


def iterate_and_load(argv: list[str]) -> int:
	if len(argv) < 3:
	return 1
	msg = argv[0]
	find_path = argv[1]
	find_term = argv[2]
	filter_fn = argv[3] if len(argv) > 3 else ""
	log_start([msg])
	log_debug([f"find_path={find_path} • find_term={find_term} • filter_fn={filter_fn}"])
	matches = []
	base = Path(find_path)
	if base.exists():
	for path in base.rglob(find_term):
		matches.append(str(path))
	if filter_fn:
	import shlex

	result = run(shlex.split(filter_fn), capture=True, input_data="\n".join(matches))
	matches = result.stdout.splitlines()
	for script in sorted(matches):
	log_debug([f"loading {script}"])
	run(["/bin/sh", script])
	log_finish([msg])
	return 0


def jump_last_line(argv: list[str]) -> int:
	print("\033[1A\033[K", end="")
	return 0


def kube_shell(argv: list[str]) -> int:
	image = Path.cwd().name
	if argv:
	image = argv[0]
	print(f"Opening shell into pod '{image}'...")
	return run(["kubectl", "exec", "-it", image, "sh"]).returncode


def ls_2_exa(argv: list[str]) -> int:
	if not which("exa"):
	log_warn(["exa is not installed"])
	return run(["/bin/ls", *argv]).returncode
	args = [a.replace("A", "a") for a in argv]
	cmd = [
	"/usr/bin/exa",
	"--all",
	"--oneline",
	"--long",
	"--classify",
	"--icons",
	"--color",
	"always",
	"--group-directories-first",
	"--header",
	"--octal-permissions",
	*args,
	]
	return run(cmd).returncode


def mic_on(argv: list[str]) -> int:
	run(["pacmd", "set-source-mute", "2", "0"])
	return mic_state([])


def mic_muted(argv: list[str]) -> int:
	run(["pacmd", "set-source-mute", "2", "1"])
	return mic_state([])


def mic_state(argv: list[str]) -> int:
	result = run(["pacmd", "list-sources"], capture=True)
	state = "on"
	if result.returncode == 0:
	lines = result.stdout.splitlines()
	found = False
	for line in lines:
		if line.strip().startswith("index: 2"):
			found = True
			continue
		if found and line.strip().startswith("index:"):
			break
		if found and "muted:" in line:
			state = "muted" if "yes" in line else "on"
			break
	print(f"mic is {state}")
	return 0


def mic_zsh(argv: list[str]) -> int:
	if not argv:
	return mic_on([])
	cmd = argv[0]
	rest = argv[1:]
	if cmd in {"on", "mic_on"}:
	return mic_on(rest)
	if cmd in {"muted", "mic_muted"}:
	return mic_muted(rest)
	if cmd in {"state", "mic_state"}:
	return mic_state(rest)
	return mic_on(argv)


def mouse_battery(argv: list[str]) -> int:
	out, _ = run_pipeline([["upower", "-e"], ["grep", "mouse"], ["xargs", "upower", "-i"], ["grep", "percentage"], ["awk", "{print $2}"]])
	if out:
	print(out.strip())
	return 0


def mvdir(argv: list[str]) -> int:
	if len(argv) < 2:
	return 1
	dest = argv[-1]
	ensure_dir(Path(dest))
	return run(["mv", *argv]).returncode


def my_lat_lon(argv: list[str]) -> int:
	out, _ = run_pipeline([["curl", "-s", "ipinfo.io"], ["jq", "-rM", ".loc"]])
	if out:
	print(out.strip())
	return 0


def npm(argv: list[str]) -> int:
	from pyfunctions import docker

	return docker.docker_run(["node", "alpine", "npm", *argv])


def php(argv: list[str]) -> int:
	from pyfunctions import docker

	return docker.docker_run(["php", "alpine", "php", *argv])


def plugins_list(argv: list[str]) -> int:
	if not argv:
	return 0
	path = Path(argv[0])
	if not path.exists():
	return 0
	items = []
	for line in path.read_text(errors="ignore").splitlines():
	stripped = line.strip()
	if not stripped or stripped.startswith("#") or stripped.startswith(";"):
		continue
	items.append(stripped.split()[0])
	print(" ".join(items))
	return 0


def progress_bar(argv: list[str]) -> int:
	if len(argv) < 2:
	return 1
	current = int(argv[0])
	target = int(argv[1])
	msg = "" if len(argv) < 3 else f"{argv[2]} | "
	bar_size = 300
	left_char = f"{color_value('bg_green')}\u2588{color_value('no')}"
	right_char = f"{color_value('bg_red')}\u2591{color_value('no')}"
	terminal_size = shutil.get_terminal_size((80, 20)).columns
	target_char_size = len(str(target))
	left_message = f"\u2581 {msg}{str(current).rjust(target_char_size)}/{target} "
	percent = int(100 * current / target) if target else 0
	right_message = f" {str(percent).rjust(3)}%"
	messages_size = len(_strip_ansi(left_message + right_message))
	total_size = messages_size + bar_size
	if total_size > terminal_size:
	bar_size = max(1, terminal_size - messages_size)
	position = int((bar_size * percent) / 100) if bar_size else 0
	bar = left_char * position + right_char * (bar_size - position)
	print(f"{left_message}{bar}{right_message}\r", end="")
	if current == target:
	print("")
	return 0


def shell_folder_summary(argv: list[str]) -> int:
	cwd = Path.cwd()
	files = len([p for p in cwd.iterdir() if p.is_file()])
	folders = len([p for p in cwd.iterdir() if p.is_dir()]) + 1
	hidden_files = len([p for p in cwd.iterdir() if p.is_file() and p.name.startswith(".")])
	output = f"{color_value('bg_white')} {cwd} {color_value('no')}"
	output += f"{color_value('bg_purple')} \U0001F4C2 {folders} {color_value('no')}"
	output += f"{color_value('bg_rose')} \U0001F4C4 {files} {color_value('no')}"
	output += f"{color_value('bg_green')} \U0001F5C4 {hidden_files} {color_value('no')}"
	print(output, end="")
	return 0


def shell_zsh(argv: list[str]) -> int:
	return which_shell([])


def spaceship_random_emoji(argv: list[str]) -> int:
	if os.environ.get("SPACESHIP_RANDOM_EMOJI_SHOW") == "false":
	return 0
	emoji = emoji_random_value(None)
	if not emoji:
	return 0
	print(emoji, end="")
	return 0


def spaceship_histsize(argv: list[str]) -> int:
	if os.environ.get("SPACESHIP_HISTSIZE_SHOW") == "false":
	return 0
	histfile = os.environ.get("HISTFILE")
	if not histfile:
	return 0
	path = Path(histfile)
	if not path.exists():
	return 0
	size = len(path.read_text(errors="ignore").splitlines())
	print(size)
	return 0


def spinnaker_config_to_env(argv: list[str]) -> int:
	if not argv:
	return 1
	import json

	data = json.loads(Path(argv[0]).read_text())
	lines = [f"{item['name']}={item['value']}" for item in data]
	for line in sorted(lines):
	print(line)
	return 0


def sudo_cmd(argv: list[str]) -> int:
	if not argv:
	return 1
	if os.getuid() == 0:
	print(f"Hi {os.environ.get('USER', '')}")
	return run(argv).returncode
	result = run(["sudo", "--non-interactive", "true"], check=False)
	if result.returncode != 0:
	log_warn(["root privileges are being requested. pay attention to what you are doing!"])
	run(["sudo", "--validate"])
	return run(["sudo", *argv]).returncode


def sudo(argv: list[str]) -> int:
	return sudo_cmd(argv)


def vercel(argv: list[str]) -> int:
	workdir = Path.cwd() / "srv"
	cmd = [
	"docker",
	"run",
	"--name",
	"dockette-vercel",
	"--rm",
	"-it",
	"-v",
	f"{Path.home()}/.local/share/com.vercel.cli:/root/.local/share/com.vercel.cli",
	"-v",
	f"{workdir}:/srv",
	"dockette/vercel",
	"vercel",
	*argv,
	]
	return run(cmd).returncode


def vscode_sanitize(argv: list[str]) -> int:
	home = Path.home()
	paths = [
	home / ".config/Code/Backups",
	home / ".config/Code/blob_storage",
	home / ".config/Code/Cache",
	home / ".config/Code/CachedData",
	home / ".config/Code/Code Cache",
	home / ".config/Code/GPUCache",
	home / ".config/Code/logs",
	home / ".config/Code/Session Storage",
	home / ".config/Code/webrtc_event_logs",
	home / ".vscode/Code/Crash Reports",
	home / ".vscode/Code/exthost Crash Reports",
	home / ".vscode/Code/Local Storage",
	home / ".vscode-server/Code/Crash Reports",
	home / ".vscode-server/Code/exthost Crash Reports",
	home / ".vscode-server/Code/Local Storage",
	]
	remove_paths(paths)
	return 0


def wallpapers_reindex(argv: list[str]) -> int:
	root = Path.home() / "sync/linux/Pictures/Wallpapers"
	run(["sh", str(root / "ubuntu-wallpaper-generator"), str(root)])
	target = Path("/usr/share/gnome-background-properties/ubuntu-wallpapers.xml")
	if not target.exists() or target.stat().st_size == 0:
	run(["sudo", "touch", str(target)])
	run(["sudo", "cp", str(target), str(target) + ".backup"])
	run(["sudo", "mv", "ubuntu-wallpapers.xml", str(target)])
	return 0


def weather(argv: list[str]) -> int:
	return run(["curl", "wttr.in"]).returncode


def weather_by_lat_lon(argv: list[str]) -> int:
	lat_lon = os.environ.get("LATLON") or ""
	if not lat_lon:
	result = run(["curl", "-s", "ipinfo.io"], capture=True)
	if result.stdout:
		try:
			import json

			lat_lon = json.loads(result.stdout).get("loc", "")
		except Exception:
			lat_lon = ""
	if not lat_lon:
	return 1
	return run(["curl", "-sL", "-H", "Accept-Language: pt-br", f"wttr.in/{lat_lon}?m2AFnq&format=3"]).returncode


def zsh_autoload_paths(argv: list[str]) -> int:
	if not argv:
	return 1
	log_start(["zsh autoload paths: adding custom functions to zsh autoload (fpath)"])
	tmp_user = Path(os.environ.get("TMP_USER", str(Path.home() / "sync/tmp/unknown")))
	ensure_dir(tmp_user)
	autoload_path = tmp_user / "zsh_autoload_paths.txt"
	if not autoload_path.exists():
	paths = argv
	with autoload_path.open("w") as f:
		for raw in paths:
			f.write(f"eval \"fpath=( {raw} ${{fpath[@]}} )\"\n")
			for folder in Path(raw).expanduser().glob("*"):
				for file in folder.glob("*"):
					name = file.name
					if name == "*":
						continue
					f.write(f"autoload -Uz {name}\n")
	log_finish(["zsh autoload paths: adding custom functions to zsh autoload (fpath)"])
	return 0


def zsh_plugins_install(argv: list[str]) -> int:
	print("zsh_plugins_install is DEPRECATED, using zplug")
	return 0


def zsh_plugins_load(argv: list[str]) -> int:
	print("zsh_plugins_load is DEPRECATED, using zplug")
	return 0


def busybox_ash_shell(argv: list[str]) -> int:
	image = Path.cwd().name
	if argv:
	image = argv[0]
	print(f"Opening shell into docker '{image}'...")
	return run(["docker", "exec", "-i", "-t", image, "/bin/busybox", "ash"]).returncode
