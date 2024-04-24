$SHELL_DEBUG && echo -e "\n👾 zshenv"

export AUTO_LS_CHPWD=false
export AUTO_LS_COMMANDS='custom_function'
export AUTO_LS_NEWLINE=false
export AUTO_LS_PATH=false
export BUILDKIT_STEP_LOG_MAX_SIZE=-1
export BUILDKIT_STEP_LOG_MAX_SPEED=-1
export CASE_SENSITIVE=false
export CLICOLOR=true
export DISABLE_AUTO_TITLE=true
export DISABLE_LS_COLORS=false
export EDITOR=nano
export EMOJI_CLI_KEYBIND="^e"
export ENABLE_CORRECTION=true
export GREP_COLORS='mt=30;103'
export HISTDUP=erase # erase duplicates in the history file
export HYPHEN_INSENSITIVE=true
export LANG="en_US.UTF-8"
export LC_ALL=C # LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LESS="-erX"
export MICRO_TRUECOLOR=1
export PAGER=less
export POSH_THEME=M365Princess
export SAVEHIST=999999
export SHELL_DEBUG=false
export SHELL_PROFILE=false
export SHELL_TRACE=false
export TERM="xterm-256color"
export VISUAL=nano
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#939393,bold,underline"
export ZSH_HIGHLIGHT_MAXLENGTH=100
export ZSH_THEME_RANDOM_QUIET=true
export ZSH_THEME=random
export ZSH_WAKATIME_PROJECT_DETECTION=true

export GPG_TTY ; GPG_TTY="$(tty)"
export NOW ; NOW="$(date '+%H-%M-%S-%N')"
export SSH_AUTH_SOCK ; SSH_AUTH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
export TODAY ; TODAY="$(date '+%F')"

export DOTFILES="${DOTFILES:=${HOME}/workspaces/bernardolm/dotfiles}"

export GOPATH="${HOME}/gopath"
export SYNC_DOTFILES="${SYNC_DOTFILES:=${HOME}/sync}"
export TIMESTAMP="${TODAY}_${NOW}"
export USER_TMP="${HOME}/tmp"
export ZDOTDIR="${DOTFILES}/zsh/zdotdir"
export ZPLUG_HOME="${HOME}/.zplug"
export ZSH_CUSTOM="${HOME}/.zsh"
export ZSH="${HOME}/.oh-my-zsh"

export TODO_DIR="${DOTFILES}/todo-txt"

export DONE_FILE="${SYNC_DOTFILES}/todo-txt/done.txt"
export HISTFILE="${SYNC_DOTFILES}/zsh/.zsh_history" # where to save history to disk
export HISTSIZE="${SAVEHIST}"
export REPORT_FILE="${SYNC_DOTFILES}/todo-txt/report.txt"
export SHELL_SESSION_PATH="${USER_TMP}/shell_session/${TODAY}"
export TODO_ACTIONS_DIR="${TODO_DIR}/.todo.actions.d"
export TODO_FILE="${SYNC_DOTFILES}/todo-txt/todo.txt"
export TODOTXT_CFG_FILE="${TODO_DIR}/zsh.cfg"

if command -v git &>/dev/null; then
    GITHUB_ORG=$(git config --file \
        "${SYNC_DOTFILES}/git/.gitconfig_private" github.organization)
    export GITHUB_ORG
    GITHUB_USER=$(git config --file \
        "${DOTFILES}/.gitconfig" github.user)
    export GITHUB_USER
fi

export WORKSPACE_ORG="${HOME}/workspaces/${GITHUB_ORG}"
export WORKSPACE_USER="${HOME}/workspaces/${GITHUB_USER}"

export PATH; PATH="${PATH}:$(echo ~/.vscode-server/bin/*/bin)"
export PATH; PATH="${PATH}:$(go env GOPATH)/bin"
export PATH="${PATH}:/bin"
export PATH="${PATH}:/home/linuxbrew/.linuxbrew/bin"
export PATH="${PATH}:/snap/bin/"
export PATH="${PATH}:/usr/bin"
export PATH="${PATH}:/usr/local/bin"
export PATH="${PATH}:/usr/local/go/bin"
export PATH="${PATH}:/usr/local/java/jre/bin"
export PATH="${PATH}:${DOTFILES}/bin"
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${SYNC_DOTFILES}/bin"
