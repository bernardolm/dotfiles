plugins_off=(
    copyfile
    copypath
    docker
    docker-compose
    dotenv
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
    gnu-utils
    history
    jsontools
    last-working-dir
    pip
    pipenv
    python
    redis-cli
    ssh-agent
    sublime
    sudo
    systemd
    tmux
    ubuntu
    ufw
    virtualenv
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

plugins=(
    aliases
    aws
    battery
    bgnotify
    colored-man-pages
    colorize
    command-not-found
    common-aliases
    cp
    extract
    fzf
    git
    golang
    kubectl
    man
    nmap
    rsync
    screen
    timer
    zsh-interactive-cd
    zsh-navigation-tools
)

if $DEBUG_SHELL; then
    echo -n "oh-my-zsh plugins disabled: "
    for p in $plugins_off; do
        echo -n "$p, ";
    done
    echo ""
fi

for p in $plugins; do
    zinit snippet OMZP::$p/$p.plugin.zsh
done

zinit cdclear -q

autoload -U compinit
compinit
