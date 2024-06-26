[ -z "$SSH_TTY" ] && return

$SHELL_DEBUG && echo "👾 zshenv"

export AUTO_LS_CHPWD=false
export AUTO_LS_COMMANDS='custom_function'
export AUTO_LS_NEWLINE=false
export AUTO_LS_PATH=false
export BUILDKIT_STEP_LOG_MAX_SIZE=-1
export BUILDKIT_STEP_LOG_MAX_SPEED=-1
export CASE_SENSITIVE=false
export CLICOLOR=true
export COLORTERM=truecolor
export DISABLE_AUTO_TITLE=true
export DISABLE_LS_COLORS=false
export EDITOR='nano'
export EMOJI_CLI_KEYBIND='^e'
export ENABLE_CORRECTION=true
export GREP_COLORS='mt=30;103'
export HISTDUP='erase' # erase duplicates in the history file
export HYPHEN_INSENSITIVE=true
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LESS='-erX'
export MICRO_TRUECOLOR=1
export PAGER='less'
export SAVEHIST=999999
export SHELL_DEBUG=false
export SHELL_PROFILE=false
export SHELL_TRACE=false
export TERM='xterm-256color'
export VISUAL='nano'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="underline"
export ZSH_HIGHLIGHT_MAXLENGTH=100
export ZSH_THEME_RANDOM_QUIET=true
export ZSH_THEME='random'
export ZSH_WAKATIME_PROJECT_DETECTION=true
export POWERLINE_ROOT='/home/bernardo/.local/lib/python3.11/site-packages/powerline'

export DOTFILES ; DOTFILES="${DOTFILES:=${HOME}/workspaces/bernardolm/dotfiles}" # 🧙‍♂️
export GOPATH ; GOPATH="${HOME}/gopath"
export GPG_TTY ; GPG_TTY="$(tty)"
export HOSTNAME="$(hostname)"
export NOW ; NOW="$(date '+%H-%M-%S-%N')"
export SSH_AUTH_SOCK ; SSH_AUTH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
export SYNC_DOTFILES ; SYNC_DOTFILES="${SYNC_DOTFILES:=${HOME}/sync}" # 🧙‍♂️
export TODAY ; TODAY="$(date '+%F')"
export USER_TMP ; USER_TMP="${HOME}/tmp"
export VSCODE_CLI_DATA_DIR ; VSCODE_CLI_DATA_DIR="${HOME}/.vscode-server/cli"
export ZPLUG_HOME ; ZPLUG_HOME="${HOME}/.zplug"
export ZSH ; ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM ; ZSH_CUSTOM="${HOME}/.zsh"
export ZSH_WAKATIME_BIN ; ZSH_WAKATIME_BIN="${HOME}/.local/bin/wakatime-cli"

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
        "${SYNC_DOTFILES}/git/.gitconfig_private" github.organization)
    export GITHUB_USER ; GITHUB_USER=$(git config --file \
        "${DOTFILES}/.gitconfig" github.user)
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
