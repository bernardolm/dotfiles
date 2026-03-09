# POSIX/ash profile for lightweight environments (e.g. Alpine).

export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/dotfiles/terminal/starship/theme/starship.toml}"

case "$-" in
	*i*)
		if command -v starship >/dev/null 2>&1; then
			eval "$(starship init sh)"
		fi
		;;
esac
