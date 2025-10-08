reset

set -e

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac
(( $+ZSH_NO_RCS )) && tput init && zsh --no-rcs "$@" && exit

#command -v zellij &>/dev/null || sudo ln -sf $HOME/sync/linux/bin/zellij /usr/local/bin/zellij
#eval "$(zellij setup --generate-auto-start zsh)"

((SHELL_DEBUG)) && echo ".zshenv"

source $HOME/workspaces/bernardolm/dotfiles/zsh/functions/now
export SESSION_ID=$(now)

export SHELL_DEBUG ; SHELL_DEBUG=0
export SHELL_PROFILE ; SHELL_PROFILE=0
export SHELL_TRACE ; SHELL_TRACE=0

export ATUIN_NOBIND ; ATUIN_NOBIND=true
export BUILDKIT_STEP_LOG_MAX_SIZE ; BUILDKIT_STEP_LOG_MAX_SIZE=-1
export BUILDKIT_STEP_LOG_MAX_SPEED ; BUILDKIT_STEP_LOG_MAX_SPEED=-1
# export CASE_SENSITIVE ; CASE_SENSITIVE=false
export CLICOLOR ; CLICOLOR=true
export CLR__BG_PURPLE ; CLR__BG_PURPLE="\e[38;5;15m\e[48;5;129m\e[1m"
export CLR_BG_BLUE ; CLR_BG_BLUE="\e[38;5;15m\e[48;5;21m\e[1m"
export CLR_BG_CYAN ; CLR_BG_CYAN="\e[38;5;235m\e[48;5;51m\e[1m"
export CLR_BG_GREEN ; CLR_BG_GREEN="\e[38;5;235m\e[48;5;40m\e[1m"
export CLR_BG_GREY ; CLR_BG_GREY="\e[38;5;235m\e[48;5;253m\e[1m"
export CLR_BG_RED ; CLR_BG_RED="\e[38;5;235m\e[48;5;9m\e[1m"
export CLR_BG_ROSE ; CLR_BG_ROSE="\e[38;5;15m\e[48;5;201m\e[1m"
export CLR_BG_WHITE ; CLR_BG_WHITE="\e[38;5;235m\e[48;5;5m\e[1m"
export CLR_BG_YELLOW ; CLR_BG_YELLOW="\e[38;5;235m\e[48;5;226m\e[1m"
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
export NO_COLOR ; NO_COLOR="\e[0m"
export PAGER ; PAGER=less
export POWERLINE_ROOT ; POWERLINE_ROOT="$HOME/.local/lib/python3.11/site-packages/powerline"
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

export CURRENT_PUBLIC_IP ; CURRENT_PUBLIC_IP=$(curl -sL checkip.amazonaws.com)
export DOTFILES ; DOTFILES="${DOTFILES:=$HOME/workspaces/bernardolm/dotfiles}" # 🧙‍♂️

# operating system specific
export OS ; OS=$(uname | tr '[:upper:]' '[:lower:]')
source "$DOTFILES/$OS/start"

export GID ; GID=$(id -g)
export GOPATH ; GOPATH="$HOME/gopath"
export GPG_TTY ; GPG_TTY=$(tty)
export HISTSIZE ; HISTSIZE="$SAVEHIST"
export HOSTNAME ; HOSTNAME=$(hostname)
export SSH_AGENT_OUTPUT_SCRIPT ; SSH_AGENT_OUTPUT_SCRIPT="$HOME/.ssh/ssh-agent"
export UID ; UID=$(id -u)
export USER_TMP ; USER_TMP="$HOME/tmp"
export VSCODE_CLI_DATA_DIR ; VSCODE_CLI_DATA_DIR="$HOME/.vscode-server/cli"
export ZPLUG_HOME ; ZPLUG_HOME="$HOME/.zplug"
export ZSH ; ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM ; ZSH_CUSTOM="$ZSH/custom"
export ZSH_REPOS ; ZSH_REPOS="$HOME/.zsh"

export DONE_FILE ; DONE_FILE="$HOME/sync/linux/todo-txt/done.txt"
export ELAPSED_TIME_ROOT ; ELAPSED_TIME_ROOT="$USER_TMP/elapsed_time/$SESSION_ID"
export REPORT_FILE ; REPORT_FILE="$HOME/sync/linux/todo-txt/report.txt"
export TODO_DIR ; TODO_DIR="$DOTFILES/todo-txt"
export TODO_FILE ; TODO_FILE="$HOME/sync/linux/todo-txt/todo.txt"
export ZDOTDIR ; ZDOTDIR="$DOTFILES/zsh/zdotdir"

export TODO_ACTIONS_DIR ; TODO_ACTIONS_DIR="$TODO_DIR/.todo.actions.d"
export TODOTXT_CFG_FILE ; TODOTXT_CFG_FILE="$TODO_DIR/zsh.cfg"

if which git &>/dev/null; then
	export GITHUB_ORG ; GITHUB_ORG=$(git config --file \
		"$HOME/sync/shared/home/.gitconfig" github.organization)
	export GITHUB_USER ; GITHUB_USER=$(git config --file \
		"$DOTFILES/git/.gitconfig" github.user)
fi

export WORKSPACE_ORG ; WORKSPACE_ORG="$HOME/workspaces/$GITHUB_ORG"
export WORKSPACE_USER ; WORKSPACE_USER="$HOME/workspaces/$GITHUB_USER"

PATH+=":/bin"
PATH+=":/home/linuxbrew/.linuxbrew/bin"
PATH+=":/mnt/c/WINDOWS/system32"
PATH+=":/snap/bin"
PATH+=":/usr/bin"
PATH+=":/usr/local/bin"
PATH+=":/usr/local/go/bin"
PATH+=":/usr/local/java/jre/bin"
PATH+=":$DOTFILES/bin"
PATH+=":$HOME/.atuin/bin"
PATH+=":$HOME/.cargo/bin"
PATH+=":$HOME/.local/bin"
PATH+=":$HOME/bin"
PATH+=":$HOME/gopath/bin"
PATH+=":$HOME/sync/linux/bin"
PATH+=":/opt/homebrew/opt/curl/bin"

if [[ $(test -f /proc/version && grep -i Microsoft /proc/version) ]]; then
  export WSL_SYSTEM ; WSL_SYSTEM=true
fi

mkdir -m u=rwX,g=rX -p \
	"$DOTFILES/git/modules" \
	"$ELAPSED_TIME_ROOT" \
	"$GOPATH" \
	"$HOME/.local/bin" \
	"$USER_TMP" \
	"$WORKSPACE_ORG" \
	"$WORKSPACE_USER" \
  "$HOME/sync/linux/crontab/"

echo "🤖 \"$(whoami)\" using \"$OS\" at \"$IP_CURRENT\""
