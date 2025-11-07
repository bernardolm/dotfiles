command -v atuin &>/dev/null \
	&& log start "atuin" \
	&& eval "$(atuin init zsh)" \
	&& log finish "atuin"