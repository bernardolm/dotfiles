# Shared environment for all zsh sessions.

export ZDOTDIR="$HOME/dotfiles/terminal/zsh/zdotdir"
export ZIM_CONFIG_FILE="$HOME/dotfiles/terminal/zsh/.zimrc"
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"

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

if [ -z "${DOTFILES_PROFILE:-}" ]; then
	if [ "$DOTFILES_OS" = "linux" ] && [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
		export DOTFILES_PROFILE="server"
	else
		export DOTFILES_PROFILE="desktop"
	fi
fi

export STARSHIP_CONFIG="$HOME/dotfiles/terminal/starship/theme/starship.toml"
if [ -d "$HOME/dotfiles/bin" ] && [[ ":$PATH:" != *":$HOME/dotfiles/bin:"* ]]; then
	export PATH="$PATH:$HOME/dotfiles/bin"
fi
export PATH="$PATH:$HOME/go/bin"
export LUA_PATH="${LUA_PATH:-};$HOME/dotfiles/terminal/wezterm/?.lua"

dotfiles_tmp_root="${TMPDIR:-/tmp}"
dotfiles_zsh_tmp_dir="${dotfiles_tmp_root%/}/dotfiles-zsh-${USER:-user}"
mkdir -p "$dotfiles_zsh_tmp_dir" 2>/dev/null || true

# Disable Apple Terminal resume sessions and avoid creating .zsh_sessions under ZDOTDIR.
export SHELL_SESSIONS_DISABLE=1
export SHELL_SESSION_HISTORY=0
export SHELL_SESSION_DIR="$dotfiles_zsh_tmp_dir/sessions"

# Force zcomp* artifacts to temporary storage.
export ZSH_COMPDUMP="$dotfiles_zsh_tmp_dir/.zcompdump-${HOST:-local}"

dotfiles_history_official="$HOME/sync/.zsh_history"
if [ -n "${HISTFILE:-}" ] && [ "$HISTFILE" != "$dotfiles_history_official" ]; then
	export DOTFILES_HISTFILE_PREVIOUS="$HISTFILE"
fi
export HISTFILE="$dotfiles_history_official"
