# for dir in /home/bernardo/.zinit/plugins/zsh-users* ; do
#     zsh_plugin_name=("${(@s/---/)dir}")

#     init_file=$dir/${zsh_plugin_name[2]}.zsh
#     init_file_plugin=$dir/${zsh_plugin_name[2]}.plugin.zsh

#     if [ -f "$init_file" ]; then
#         source $init_file
#     elif [ -f "$init_file_plugin" ]; then
#         source $init_file_plugin
#     else
#         ll $dir
#     fi
# done

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
    zsh-autosuggestions
    zsh-completions
    zsh-interactive-cd
    zsh-syntax-highlighting
)

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk
export HISTSIZE=99999
export SAVEHIST=$HISTSIZE

export HIST_STAMPS="yyyy-mm-dd"

setopt extended_history
setopt inc_append_history
setopt share_history
unsetopt hist_save_by_copy
setopt hist_ignore_dups

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

export ZSH_HIGHLIGHT_STYLES[default]=none
export ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
export ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
export ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
export ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
export ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
export ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
export ZSH_HIGHLIGHT_STYLES[commandseparator]=none
export ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
export ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
export ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
export ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
export ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
export ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
export ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
export ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
export ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
export ZSH_HIGHLIGHT_STYLES[assign]=none
