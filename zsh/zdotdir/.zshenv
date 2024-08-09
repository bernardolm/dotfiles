# [ -z "$SSH_TTY" ] && return

$SHELL_DEBUG && echo "👾 zshenv"

export BUILDKIT_STEP_LOG_MAX_SIZE=-1
export BUILDKIT_STEP_LOG_MAX_SPEED=-1
export CASE_SENSITIVE=false
export CLICOLOR=true
export CLR_BLUE="\e[38;5;15m\e[48;5;21m\e[1m"
export CLR_CYAN="\e[38;5;235m\e[48;5;51m\e[1m"
export CLR_GREEN="\e[38;5;235m\e[48;5;40m\e[1m"
export CLR_GREY="\e[38;5;235m\e[48;5;253m\e[1m"
export CLR_PURPLE="\e[38;5;15m\e[48;5;129m\e[1m"
export CLR_RED="\e[38;5;235m\e[48;5;9m\e[1m"
export CLR_ROSE="\e[38;5;15m\e[48;5;201m\e[1m"
export CLR_WHITE="\e[38;5;235m\e[48;5;5m\e[1m"
export CLR_YELLOW="\e[38;5;235m\e[48;5;226m\e[1m"
export COLORTERM=truecolor
export DISABLE_AUTO_TITLE=true
export DISABLE_LS_COLORS=false
export EDITOR='nano'
export EMOJI_CLI_KEYBIND='^e'
export ENABLE_CORRECTION=true
export GIT_DISCOVERY_ACROSS_FILESYSTEM=true
export GREP_COLORS='mt=30;103'
export HISTDUP='erase' # erase duplicates in the history file
export HYPHEN_INSENSITIVE=true
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LESS='-erX'
export MICRO_TRUECOLOR=1
export NO_COLOR="\e[0m"
export PAGER='less'
export POWERLINE_ROOT='/home/bernardo/.local/lib/python3.11/site-packages/powerline'
export SAVEHIST=999999
export SHELL_DEBUG=false
export SHELL_PROFILE=false
export SHELL_TRACE=false
export SSH_AGENT_PID=-1
export TERM='xterm-256color'
export VISUAL='nano'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="underline"
export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
export ZSH_COLORIZE_TOOL=chroma
export ZSH_HIGHLIGHT_MAXLENGTH=100
export ZSH_WAKATIME_PROJECT_DETECTION=true

export DOTFILES ; DOTFILES="${DOTFILES:=${HOME}/workspaces/bernardolm/dotfiles}" # 🧙‍♂️
export GOPATH ; GOPATH="${HOME}/gopath"
export GPG_TTY ; GPG_TTY="$(tty)"
export HOSTNAME="$(hostname)"
export NOW ; NOW="$(date '+%H-%M-%S-%N')"
export PROMPT=$(random_emoji fruits)"  > ${PROMPT}"
export SSH_AUTH_SOCK ; SSH_AUTH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
export SYNC_DOTFILES ; SYNC_DOTFILES="${SYNC_DOTFILES:=${HOME}/sync}" # 🧙‍♂️
export TODAY ; TODAY="$(date '+%F')"
export USER_TMP ; USER_TMP="${HOME}/tmp"
export VSCODE_CLI_DATA_DIR ; VSCODE_CLI_DATA_DIR="${HOME}/.vscode-server/cli"
export ZPLUG_HOME ; ZPLUG_HOME="${HOME}/.zplug"
export ZSH ; ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM ; ZSH_CUSTOM="${HOME}/.zsh"

export DONE_FILE ; DONE_FILE="${SYNC_DOTFILES}/todo-txt/done.txt"
export HISTFILE ; HISTFILE="${SYNC_DOTFILES}/zsh/.zsh_history" # where to save history to disk
export HISTSIZE ; HISTSIZE="${SAVEHIST}"
export REPORT_FILE ; REPORT_FILE="${SYNC_DOTFILES}/todo-txt/report.txt"
export SHELL_SESSION_PATH ; SHELL_SESSION_PATH="${USER_TMP}/shell_session/${TODAY}"
export TIMESTAMP ; TIMESTAMP="${TODAY}_${NOW}"
export TODO_DIR ; TODO_DIR="${DOTFILES}/todo-txt"
export TODO_FILE ; TODO_FILE="${SYNC_DOTFILES}/todo-txt/todo.txt"
export ZDOTDIR ; ZDOTDIR="${DOTFILES}/zsh/zdotdir"

export TODO_ACTIONS_DIR ; TODO_ACTIONS_DIR="${TODO_DIR}/.todo.actions.d"
export TODOTXT_CFG_FILE ; TODOTXT_CFG_FILE="${TODO_DIR}/zsh.cfg"

if which git &>/dev/null; then
    export GITHUB_ORG ; GITHUB_ORG=$(git config --file \
        "${SYNC_DOTFILES}/git/.gitconfig.work" github.organization)
    export GITHUB_USER ; GITHUB_USER=$(git config --file \
        "${DOTFILES}/git/.gitconfig" github.user)
fi

export WORKSPACE_ORG ; WORKSPACE_ORG="${HOME}/workspaces/${GITHUB_ORG}"
export WORKSPACE_USER ; WORKSPACE_USER="${HOME}/workspaces/${GITHUB_USER}"

export PATH
PATH="${PATH}:/bin"
PATH="${PATH}:/home/linuxbrew/.linuxbrew/bin"
PATH="${PATH}:/snap/bin/"
PATH="${PATH}:/usr/bin"
PATH="${PATH}:/usr/local/bin"
PATH="${PATH}:/usr/local/go/bin"
PATH="${PATH}:/usr/local/java/jre/bin"
PATH="${PATH}:${DOTFILES}/bin"
PATH="${PATH}:${GOPATH}/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/bin"
PATH="${PATH}:${HOME}/go/bin"
PATH="${PATH}:${SYNC_DOTFILES}/bin"
