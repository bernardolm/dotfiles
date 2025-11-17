set -e

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac
(( $+ZSH_NO_RCS )) && tput init && zsh --no-rcs "$@" && exit

reset

# command -v zellij &>/dev/null || sudo ln -sf $HOME/sync/linux/bin/zellij /usr/local/bin/zellij
# eval "$(zellij setup --generate-auto-start zsh)"

echo ".zshenv"

source $HOME/workspaces/bernardolm/dotfiles/zsh/functions/now
export SESSION_ID=$(now)

export SHELL_DEBUG ; SHELL_DEBUG=1 ; \
	((SHELL_DEBUG)) && echo '> shell debug activated'
export SHELL_PROFILE ; SHELL_PROFILE=0 ; \
	((SHELL_PROFILE)) && echo '> shell profile activated'
export SHELL_TRACE ; SHELL_TRACE=1 ; \
	((SHELL_TRACE)) && echo '> shell trace activated'

export ATUIN_NOBIND ; ATUIN_NOBIND=true
export BUILDKIT_STEP_LOG_MAX_SIZE ; BUILDKIT_STEP_LOG_MAX_SIZE=-1
export BUILDKIT_STEP_LOG_MAX_SPEED ; BUILDKIT_STEP_LOG_MAX_SPEED=-1
export CLICOLOR ; CLICOLOR=true
export COLORTERM ; COLORTERM=truecolor
export COMPLETION_WAITING_DOTS ; COMPLETION_WAITING_DOTS=true
export DISABLE_AUTO_TITLE ; DISABLE_AUTO_TITLE=true
export DISABLE_LS_COLORS ; DISABLE_LS_COLORS=false
export EDITOR ; EDITOR=nano
export EMOJI_CLI_KEYBIND ; EMOJI_CLI_KEYBIND="^e"
export ENABLE_CORRECTION ; ENABLE_CORRECTION=false
export GIT_DISCOVERY_ACROSS_FILESYSTEM ; GIT_DISCOVERY_ACROSS_FILESYSTEM=true
export GREP_COLORS ; GREP_COLORS="mt=30;103"
export HISTDUP ; HISTDUP=erase # erase duplicates in the history file
export HYPHEN_INSENSITIVE ; HYPHEN_INSENSITIVE=true
export LANG ; LANG="en_US.UTF-8"
export LANGUAGE ; LANGUAGE="en_US.UTF-8"
export LC_ALL ; LC_ALL="en_US.UTF-8"
export LC_CTYPE ; LC_CTYPE="en_US.UTF-8"
export LESS ; LESS="-erX"
export MICRO_TRUECOLOR ; MICRO_TRUECOLOR=1
export MY_PLACE ; MY_PLACE=home
export PAGER ; PAGER=less
export SAVEHIST ; SAVEHIST=999999
export SPACESHIP_EXEC_TIME_SHOW ; SPACESHIP_EXEC_TIME_SHOW=false
export SSH_AGENT_PID ; SSH_AGENT_PID=-1
export TERM ; TERM="xterm-256color"
export VISUAL ; VISUAL=nano
export ZELLIJ_AUTO_ATTACH ; ZELLIJ_AUTO_ATTACH=false
export ZELLIJ_AUTO_EXIT ; ZELLIJ_AUTO_EXIT=false
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE ; ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=underline
export ZSH_COLORIZE_CHROMA_FORMATTER ; ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_TOOL ; ZSH_COLORIZE_TOOL=chroma
export ZSH_DISABLE_COMPFIX ; ZSH_DISABLE_COMPFIX=true
export ZSH_HIGHLIGHT_MAXLENGTH ; ZSH_HIGHLIGHT_MAXLENGTH=100
export ZSH_WAKATIME_PROJECT_DETECTION ; ZSH_WAKATIME_PROJECT_DETECTION=true

export DOTFILES ; DOTFILES="${DOTFILES:=$HOME/workspaces/bernardolm/dotfiles}" # 🧙‍♂️

# operating system specific
export OS ; OS=$(uname | tr '[:upper:]' '[:lower:]')
source "$DOTFILES/$OS/start"
source "$HOME/sync/$OS/scripts/start"

export TMP_USER ; TMP_USER="$HOME/sync/tmp/$HOSTNAME"

export IP_PUBLIC ; IP_PUBLIC=$(curl -sL checkip.amazonaws.com)
export GID ; GID=$(id -g)
export GPG_TTY ; GPG_TTY=$(tty)
export UID ; UID=$(id -u)

export ELAPSED_TIME_ROOT ; ELAPSED_TIME_ROOT="$TMP_USER/elapsed_time/$SESSION_ID"
export GOPATH ; GOPATH="$HOME/gopath"
export HISTSIZE ; HISTSIZE="$SAVEHIST"
export NANORC_FILE ; NANORC_FILE="$HOME/.nanorc"
export POWERLINE_ROOT ; POWERLINE_ROOT="$HOME/.local/lib/python3.11/site-packages/powerline"
export PYENV_ROOT ; PYENV_ROOT="$HOME/.pyenv"
export VSCODE_CLI_DATA_DIR ; VSCODE_CLI_DATA_DIR="$HOME/.vscode-server/cli"
export ZDOTDIR ; ZDOTDIR="$DOTFILES/zsh/zdotdir"
export ZPLUG_HOME ; ZPLUG_HOME="$HOME/.zplug"
export ZSH ; ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM ; ZSH_CUSTOM="$ZSH/custom"
export ZSH_REPOS ; ZSH_REPOS="$HOME/.zsh"

# export DONE_FILE ; DONE_FILE="$HOME/sync/linux/todo-txt/done.txt"
# export REPORT_FILE ; REPORT_FILE="$HOME/sync/linux/todo-txt/report.txt"
# export TODO_ACTIONS_DIR ; TODO_ACTIONS_DIR="$HOME/sync/linux/todo-txt/.todo.actions.d"
# export TODO_DIR ; TODO_DIR="$DOTFILES/todo-txt"
# export TODO_FILE ; TODO_FILE="$HOME/sync/linux/todo-txt/todo.txt"
# export TODOTXT_CFG_FILE ; TODOTXT_CFG_FILE="$HOME/sync/linux/todo-txt/zsh.cfg"

if which git &>/dev/null; then
	export GITHUB_ORG ; GITHUB_ORG=$(git config --file \
		"$HOME/sync/shared/home/.gitconfig" github.organization)
	export GITHUB_USER ; GITHUB_USER=$(git config --file \
		"$DOTFILES/git/.gitconfig" github.user)
fi

export WORKSPACE_ORG ; WORKSPACE_ORG="$HOME/workspaces/$GITHUB_ORG"
export WORKSPACE_USER ; WORKSPACE_USER="$HOME/workspaces/$GITHUB_USER"

PATH+=":/bin:/usr/bin:/usr/sbin:/usr/local/bin:/sbin"
PATH+=":/usr/local/go/bin"
PATH+=":/usr/local/java/jre/bin"
PATH+=":$DOTFILES/bin"
PATH+=":$HOME/.atuin/bin"
PATH+=":$HOME/.cargo/bin"
PATH+=":$HOME/.local/bin"
PATH+=":$HOME/bin"
PATH+=":$HOME/gopath/bin"
PATH+=":$HOME/sync/$OS/bin"
PATH+=":$HOME/sync/bin"
PATH+=":$PYENV_ROOT/bin"
export PATH

if [[ $(test -f /proc/version && grep -i Microsoft /proc/version) ]]; then
  export IS_WSL ; IS_WSL=1
fi

mkdir -m u=rwX,g=rX -p \
	"$DOTFILES/git/modules" \
	"$ELAPSED_TIME_ROOT" \
	"$GOPATH" \
	"$HOME/.local/bin" \
	"$TMP_USER" \
	"$WORKSPACE_ORG" \
	"$WORKSPACE_USER" \
  "$HOME/sync/linux/crontab/"

source "$DOTFILES/zsh/functions/color"
# 🌐📡📶
echo "👤 $(color cyan)$(whoami)$(color no) is using 💽 $(color rose)$OS$(color no) at 📍 $(color light_green)$IP_CURRENT$(color no)"
