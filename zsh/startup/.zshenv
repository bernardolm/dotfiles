export CLICOLOR=true
export EDITOR=nano
export EMOJI_CLI_KEYBIND="^e"
export GOROOT="/usr/local/go"
export GPG_TTY="$(tty)"
export HISTDUP=erase # Erase duplicates in the history file
export LANG="en_US.UTF-8"
export MICRO_TRUECOLOR=1
export NOW="$(date '+%H-%M-%S-%N')"
export PAGER=less
export SAVEHIST=999999
export SHELL_DEBUG=true
export SHELL_PROFILE=false
export SHELL_STACK=true
export TERM="xterm-256color"
export TODAY="$(date '+%F')"
export VISUAL=nano
export ZSH_THEME=robbyrussell
export ZSH_WAKATIME_PROJECT_DETECTION=true

export FZF_DEFAULT_OPTS='--height=50% --layout=reverse --border --inline-info --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# export DRACULA_TYPEWRITTEN_COLOR_MAPPINGS="primary:#d5ccff;secondary:#9580ff;info_neutral_1:#d0ffcc;info_neutral_2:#ffffcc;info_special:#ff9580;info_negative:#ff5555;notice:#ffff80;accent:#d5ccff"
# export TYPEWRITTEN_COLOR_MAPPINGS="${DRACULA_TYPEWRITTEN_COLOR_MAPPINGS}"
# export TYPEWRITTEN_PROMPT_LAYOUT="half_pure"
# export TYPEWRITTEN_SYMBOL="λ "

export DOTFILES="$HOME/workspaces/bernardolm/dotfiles"
export GOPATH="$HOME/gopath"
export SYNC_DOTFILES="$HOME/sync"
export USER_TMP="$HOME/tmp"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"
export ZSH_HOME="$HOME/.zsh"
export ZSH="$HOME/.oh-my-zsh"

export HISTFILE="$SYNC_DOTFILES/.zsh_history" # Where to save history to disk
export TODO_DIR="$DOTFILES/todo-txt"

export DONE_FILE="$SYNC_DOTFILES/todo-txt/done.txt"
export HISTSIZE="$SAVEHIST"
export REPORT_FILE="$SYNC_DOTFILES/todo-txt/report.txt"
export SHELL_SESSION_PATH="$USER_TMP/shell_session/$TODAY"
export TODO_ACTIONS_DIR="$TODO_DIR/.todo.actions.d"
export TODO_FILE="$SYNC_DOTFILES/todo-txt/todo.txt"
export TODOTXT_CFG_FILE="$TODO_DIR/zsh.cfg"

export GITHUB_ORG=$(git config --file \
    "$SYNC_DOTFILES/.gitconfig_work" github.organization)
export GITHUB_USER=$(git config --file \
    "$DOTFILES/.gitconfig" github.user)

export WORKSPACE_ORG="$HOME/workspaces/$GITHUB_ORG"
export WORKSPACE_USER="$HOME/workspaces/$GITHUB_USER"

export PATH="$PATH:/bin"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
export PATH="$PATH:/snap/bin/"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/usr/local/java/jre/bin"
export PATH="$PATH:$DOTFILES/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$SYNC_DOTFILES/bin"
