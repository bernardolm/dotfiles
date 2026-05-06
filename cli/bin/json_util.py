from __future__ import annotations


__all__ = ["strip_jsonc_comments"]


def strip_jsonc_comments(content: str) -> str:
	result: list[str] = []
	in_string = False
	escaped = False
	i = 0

	while i < len(content):
		ch = content[i]
		nxt = content[i + 1] if i + 1 < len(content) else ""

		if in_string:
			result.append(ch)
			if escaped:
				escaped = False
			elif ch == "\\":
				escaped = True
			elif ch == '"':
				in_string = False
			i += 1
			continue

		if ch == '"':
			in_string = True
			result.append(ch)
			i += 1
			continue

		if ch == "/" and nxt == "/":
			i += 2
			while i < len(content) and content[i] != "\n":
				i += 1
			continue

		if ch == "/" and nxt == "*":
			i += 2
			while i + 1 < len(content) and not (content[i] == "*" and content[i + 1] == "/"):
				i += 1
			i += 2
			continue

		result.append(ch)
		i += 1

	return "".join(result)
