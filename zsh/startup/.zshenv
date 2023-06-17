export CLICOLOR=true
export DOCKER=$(which docker)
export EDITOR=nano
export EMOJI_CLI_KEYBIND="^e"
export GOROOT="/usr/local/go"
export GPG_TTY="$(tty)"
export HISTDUP=erase # Erase duplicates in the history file
export LANG="en_US.UTF-8"
export MICRO_TRUECOLOR=1
export NOW="$(date '+%H-%M-%S-%N')"
export PAGER=less
export POSH_THEME=M365Princess
export SAVEHIST=999999
export SHELL_DEBUG=false
export SHELL_PROFILE=false
export SHELL_STACK=false
export TERM="xterm-256color"
export TODAY="$(date '+%F')"
export VISUAL=nano
# export ZSH_THEME=flazz
export ZSH_THEME=dracula
export ZSH_WAKATIME_PROJECT_DETECTION=true

export DOTFILES="${DOTFILES:=${HOME}/workspaces/bernardolm/dotfiles}"
export GOPATH="${HOME}/gopath"
export SYNC_DOTFILES="${SYNC_DOTFILES:=${HOME}/sync}"
export TIMESTAMP="${TODAY}_${NOW}"
export USER_TMP="${HOME}/tmp"
export ZSH_HOME="${HOME}/.zsh"
export ZSH="${HOME}/.oh-my-zsh"

export HISTFILE="${SYNC_DOTFILES}/zsh/.zsh_history" # Where to save history to disk
export TODO_DIR="${DOTFILES}/todo-txt"

export DONE_FILE="${SYNC_DOTFILES}/todo-txt/done.txt"
export HISTSIZE="${SAVEHIST}"
export REPORT_FILE="${SYNC_DOTFILES}/todo-txt/report.txt"
export SHELL_SESSION_PATH="${USER_TMP}/shell_session/${TODAY}"
export TODO_ACTIONS_DIR="${TODO_DIR}/.todo.actions.d"
export TODO_FILE="${SYNC_DOTFILES}/todo-txt/todo.txt"
export TODOTXT_CFG_FILE="${TODO_DIR}/zsh.cfg"

if command -v git &>/dev/null; then
    export GITHUB_ORG=$(git config --file \
        "${SYNC_DOTFILES}/git/.gitconfig_work" github.organization)
    export GITHUB_USER=$(git config --file \
        "${DOTFILES}/.gitconfig" github.user)
fi

export WORKSPACE_ORG="${HOME}/workspaces/${GITHUB_ORG}"
export WORKSPACE_USER="${HOME}/workspaces/${GITHUB_USER}"

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
