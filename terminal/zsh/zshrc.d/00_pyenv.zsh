if [ -n "${DOTFILES_PYENV_INIT_DONE:-}" ]; then
	return
fi

export DOTFILES_PYENV_INIT_DONE=1
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

if [[ -d "$PYENV_ROOT/shims" && ":$PATH:" != *":$PYENV_ROOT/shims:"* ]]; then
	export PATH="$PYENV_ROOT/shims:$PATH"
fi
if [[ -d "$PYENV_ROOT/bin" && ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
	export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv >/dev/null 2>&1; then
	eval "$(pyenv init - --no-rehash zsh)"
fi
