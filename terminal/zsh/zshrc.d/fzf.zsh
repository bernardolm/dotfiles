if command -v fzf >/dev/null 2>&1; then
	# shellcheck disable=SC1090
	source <(fzf --zsh)
fi
