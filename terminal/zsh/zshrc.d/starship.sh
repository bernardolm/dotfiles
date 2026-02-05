# Starship prompt.
if ! command -v starship >/dev/null 2>&1; then
	curl -sS https://starship.rs/install.sh | sh
fi
eval "$(starship init zsh)"