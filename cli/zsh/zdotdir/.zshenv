. "$HOME/dotfiles/cli/zsh/scripts/os-resolver.sh"

mkdir -p ~/tmp

# export GIT_CURL_VERBOSE=1
# export GIT_TRACE=1
export DISABLE_CORRECTION="true"
export GOPATH="${GOPATH:-$HOME/go}"
export HISTFILE="$HOME/sync/.zsh_history"
export HISTSIZE=100000
export LUA_PATH="${LUA_PATH};$HOME/dotfiles/cli/wezterm/?.lua"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"
export SAVEHIST=100000
export SHELL_SESSION_DIR="$HOME/tmp/dotfiles/shell_sessions" && mkdir -p $SHELL_SESSION_DIR
export SHELL_SESSION_HISTORY=0
export SHELL_SESSIONS_DISABLE=1
export STARSHIP_CONFIG="$HOME/dotfiles/cli/starship/theme/starship.toml"
export ZDOTDIR="$HOME/dotfiles/cli/zsh/zdotdir"
export ZIM_CONFIG_FILE="$HOME/dotfiles/cli/zsh/.zimrc"
export ZIM_HOME="${ZIM_HOME:-$HOME/.zim}"
export ZSH_COMPDUMP="$HOME/tmp/dotfiles/zcompdump" && mkdir -p $(dirname $ZSH_COMPDUMP)
