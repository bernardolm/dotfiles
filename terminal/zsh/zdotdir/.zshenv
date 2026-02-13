# Shared environment for all zsh sessions.

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
export ZDOTDIR="$DOTFILES/terminal/zsh/zdotdir"
export ZIM_CONFIG_FILE="$DOTFILES/terminal/zsh/.zimrc"
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

if [ -z "${DOTFILES_PROFILE:-}" ]; then
	if [ "$(uname -s)" = "Linux" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
		export DOTFILES_PROFILE="server"
	else
		export DOTFILES_PROFILE="desktop"
	fi
fi

case "$(uname -s)" in
	Darwin) export DOTFILES_OS="darwin" ;;
	Linux)
		if grep -qi microsoft /proc/version 2>/dev/null; then
			export DOTFILES_OS="wsl"
		else
			export DOTFILES_OS="linux"
		fi
		;;
	CYGWIN*|MINGW*|MSYS*) export DOTFILES_OS="windows" ;;
	*) export DOTFILES_OS="unknown" ;;
esac

export STARSHIP_CONFIG="$DOTFILES/terminal/starship/theme/starship.toml"
export PATH="$PATH:$HOME/go/bin"
export LUA_PATH="${LUA_PATH:-};$DOTFILES/terminal/wezterm/?.lua"

if [ -z "${HISTFILE:-}" ]; then
	export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
fi
