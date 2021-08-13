plugins=(
    bgnotify
    colored-man-pages
    colorize
    command-not-found
    cp
    docker
    docker-compose
    extract
    fd
    git
    git-extras
    git-flow
    git-hubflow
    git-prompt
    gitfast
    github
    gitignore
    golang
    jsontools
    man
    nmap
    screen
    sudo
    systemd
    ubuntu
    ufw
    virtualenv
    vscode
    zsh-interactive-cd
)

export HIST_STAMPS="yyyy-mm-dd"
export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk
export HISTSIZE=999999
export SAVEHIST=$HISTSIZE

setopt extended_history
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
unsetopt hist_save_by_copy

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

zinit load ohmyzsh/ohmyzsh
