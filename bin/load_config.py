#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path
from typing import Any


def load_config(path: Path) -> dict[str, Any]:
    content = path.read_text(errors="ignore")
    try:
        import yaml  # type: ignore

        data = yaml.safe_load(content)
        return data or {}
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
                if key == "envs":
                    data[key] = {}
                    current_section = "envs"
                elif key == "packages":
                    data[key] = []
                    current_section = "packages"
                else:
                    data[key] = ""
                    current_section = ""
            else:
                if ":" in stripped:
                    key, value = stripped.split(":", 1)
                    data[key.strip()] = value.strip()
                current_section = ""
            continue

        if current_section == "envs":
            if ":" in stripped:
                key, value = stripped.split(":", 1)
                data.setdefault("envs", {})[key.strip()] = value.strip()
            continue

        if current_section == "packages":
            if stripped.startswith("-"):
                item = stripped[1:].strip()
                if item.endswith(":"):
                    name = item[:-1].strip()
                    current_pkg = {"name": name}
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


if __name__ == "__main__":
    import argparse
    import json

    parser = argparse.ArgumentParser(description="Load a config.yml file.")
    parser.add_argument("path")
    args = parser.parse_args()

    result = load_config(Path(args.path))
    print(json.dumps(result, indent=2, sort_keys=True))
