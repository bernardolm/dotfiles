echo "\$ZDOTDIR/.zshenv"

if [[ -o norcs ]] || (( $+ZSH_NO_RCS )) || [[ "i" =~ "$-" ]] ; then
	tput init
	echo \$ZDOTDIR/.zshenv norcs
	eval $@
	return 0
fi

skip_global_compinit=1

export DOTFILES="$HOME/dotfiles"

# export WEZTERM_CONFIG_DIR="$DOTFILES/terminal/wezterm"
# export WEZTERM_CONFIG_FILE="$WEZTERM_CONFIG_DIR/wezterm.lua"
export HISTFILE="$HOME/sync/linux/home/.zsh_history"
export LUA_PATH="$LUA_PATH;$DOTFILES/terminal/wezterm/?.lua"
export PATH="$PATH:$HOME/go/bin"
export STARSHIP_CONFIG="$DOTFILES/terminal/starship/theme/starship.toml"
export ZDOTDIR="$DOTFILES/terminal/zsh/zdotdir"
export ZIM_CONFIG_FILE="$DOTFILES/terminal/zsh/.zimrc"
export ZIM_HOME="$HOME/.zim"
