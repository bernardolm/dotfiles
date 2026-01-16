echo "~/.zshenv"

if [[ -o norcs ]]; then
	echo ~/.zshenv norcs
  eval $@
	return 0
fi

# set -e

# source /etc/zshrc_Apple_Terminal

# zsh --sourcetrace -lixc '' 2>&1 | grep -E '<sourcetrace>' | cut -d '>' -f1

# `setopt` to show zsh current options
# `emulate -lLR zsh` to show zsh default options
# `emulate -LR zsh` to revert to zsh default options
# `functions -t vnc` to debug function
# `rm -f ~/.zcompdump % compinit` when building and debugging your own completion files, you may need to delete this file to force a rebuild

# sudo systemsetup -getRemoteLogin
# system_profiler

# # If not running interactively, don't do anything
# case $- in
#   * i *) ; ;
#   * ) return ; ;
# esac
# (( $+ZSH_NO_RCS )) && tput init && zsh --no-rcs "$@" && exit

# set +e
# exit 1

# source ~/.dotfiles/terminal/zsh/zdotdir/file.sh ; debug_path

export DOTFILES="$HOME/.dotfiles"

export HISTFILE="$HOME/sync/linux/home/.zsh_history"
export STARSHIP_CONFIG="$DOTFILES/terminal/starship/theme/starship.toml"
export WEZTERM_CONFIG_DIR="$DOTFILES/terminal/wezterm"
export ZDOTDIR="$DOTFILES/terminal/zsh/zdotdir"
export ZIM_CONFIG_FILE="$DOTFILES/terminal/zsh/.zimrc"
export ZIM_HOME ; ZIM_HOME="$HOME/.zim"
