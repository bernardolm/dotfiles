#!/usr/bin/env python3
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any


def load_config(path: Path) -> dict[str, Any]:
	content = path.read_text(encoding="utf-8", errors="ignore")
	try:
		import yaml  # type: ignore

		data = yaml.safe_load(content)
		if isinstance(data, dict):
			return data
		return {}
	except Exception:
		return _parse_simple_yaml(content)


def _parse_simple_yaml(content: str) -> dict[str, Any]:
	data: dict[str, Any] = {}
	current_section = ""
	current_pkg: dict[str, Any] | None = None

	for raw in content.splitlines():
		line = raw.split("#", 1)[0].rstrip()
		if not line.strip():
			continue
		indent = len(line) - len(line.lstrip())
		stripped = line.strip()

		if indent == 0:
			current_pkg = None
			if stripped.endswith(":"):
				key = stripped[:-1].strip()
				if key in {"envs", "packages", "aliases", "path", "symbolic_links"}:
					data[key] = {} if key in {"envs", "aliases", "path", "symbolic_links"} else []
					current_section = key
				else:
					data[key] = ""
					current_section = ""
			else:
				if ":" in stripped:
					key, value = stripped.split(":", 1)
					data[key.strip()] = value.strip()
				current_section = ""
			continue

		if current_section in {"envs", "aliases", "path", "symbolic_links"}:
			if ":" in stripped:
				key, value = stripped.split(":", 1)
				data.setdefault(current_section, {})[key.strip()] = value.strip()
			continue

		if current_section == "packages":
			if stripped.startswith("-"):
				item = stripped[1:].strip()
				if item.endswith(":"):
					name = item[:-1].strip()
					current_pkg = {
						"name": name
					}
					data.setdefault("packages", []).append(current_pkg)
				else:
					data.setdefault("packages", []).append(item)
					current_pkg = None
			else:
				if current_pkg is not None and ":" in stripped:
					key, value = stripped.split(":", 1)
					current_pkg[key.strip()] = value.strip()
			continue

	return data


def main() -> int:
	config_path = os.environ.get("DOTFILES_CONFIG_PATH", "").strip()
	if not config_path:
		print("error: defina DOTFILES_CONFIG_PATH para usar este script.")
		return 1
	result = load_config(Path(config_path).expanduser())
	print(json.dumps(result, indent=2, sort_keys=True))
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
