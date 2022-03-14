plugins=(
    aliases
    aws
    battery
    bgnotify
    colored-man-pages
    colorize
    command-not-found
    common-aliases
    copyfile
    copypath
    cp
    docker
    docker-compose
    dotenv
    extract
    fd
    fzf
    git
    git-extras
    git-hubflow
    git-prompt
    github
    gitignore
    gnu-utils
    golang
    history
    jsontools
    kubectl
    last-working-dir
    man
    nmap
    pip
    pipenv
    python
    redis-cli
    screen
    ssh-agent
    sublime
    sudo
    systemd
    timer
    ubuntu
    ufw
    virtualenv
    vscode
    zsh-interactive-cd
    zsh-navigation-tools
)
# git-flow
# gitfast

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

zinit load ohmyzsh/ohmyzsh
