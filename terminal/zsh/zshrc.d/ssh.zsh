if [ "$DOTFILES_OS" = "darwin" ]; then
	return
fi

if command -v ssh-agent >/dev/null 2>&1; then
	if [ ! -f "$HOME/.ssh/ssh-agent" ] || ! grep -q '^SSH_AUTH_SOCK=' "$HOME/.ssh/ssh-agent"; then
		ssh-agent -s > "$HOME/.ssh/ssh-agent"
	fi
	# shellcheck disable=SC1090
	eval "$(cat "$HOME/.ssh/ssh-agent")" >/dev/null 2>&1 || true
	ssh-add >/dev/null 2>&1 || true
fi
