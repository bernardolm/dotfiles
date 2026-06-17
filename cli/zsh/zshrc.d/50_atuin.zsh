command -v atuin >/dev/null && \
	export ATUIN_LOG=debug && \
	eval "$(atuin init zsh --disable-up-arrow)"
