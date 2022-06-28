export TERM=xterm-256color # for common 256 color terminals (e.g. gnome-terminal)
export USER_TMP=$HOME/tmp

export ZINIT_ROOT="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"

[ -d $HOME/Sync/config-backup ] && export SYNC_PATH=$HOME/Sync/config-backup
# [ -d $SYNC_PATH/bin ] && export PATH=$PATH:$SYNC_PATH/bin:

# Workspaces (at this point, isn't exist workspaces envs exported)
export GITHUB_USER=$(git config github.user)
export GITHUB_ORG=$(git config github.organization)

[ ! -z $GITHUB_ORG ] && export GOPRIVATE=github.com/$GITHUB_ORG/*

[ -d ~/workspaces/$GITHUB_USER ] && export WORKSPACE_USER=~/workspaces/$GITHUB_USER
[ ! -z $WORKSPACE_USER ] && export DOTFILES=$WORKSPACE_USER/dotfiles

source $DOTFILES/shell/load_aliases.sh
load_aliases

[ -d ~/workspaces/$GITHUB_ORG ] && export WORKSPACE_ORG=~/workspaces/$GITHUB_ORG

[ ! -d $WORKSPACE_USER ] && mkdir -p $WORKSPACE_USER
[ ! -d $WORKSPACE_ORG ] && mkdir -p $WORKSPACE_ORG

[ -d ~/gopath ] && export GOPATH=~/gopath

export PATH=$PATH:/bin
export PATH=$PATH:/snap/bin/
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.zinit/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$SYNC_PATH/bin

export BLUE="\033[0;34m"
export BOLD="\033[1m"
export FOREST_BG="\\033[48;5;22m"
export FOREST="\\033[38;5;22m"
export GRAY="\033[0;37m"
export GREEN="\033[0;32m"
export HOTPINK_BG="\\033[48;5;198m"
export HOTPINK="\\033[38;5;198m"
export JADE_BG="\\033[48;5;35m"
export JADE="\\033[38;5;35m"
export LAVENDER_BG="\\033[48;5;183m"
export LAVENDER="\\033[38;5;183m"
export LIGHT_GRAY="\033[0;37m"
export LIGHT_RED="\033[1;31m"
export LIGHTORANGE_BG="\\033[48;5;215m"
export LIGHTORANGE="\\033[38;5;215m"
export LIGHTRED_BG="\\033[48;5;203m"
export LIGHTRED="\\033[38;5;203m"
export LIME_BG="\\033[48;5;154m"
export LIME="\\033[38;5;154m"
export MAROON_BG="\\033[48;5;52m"
export MAROON="\\033[38;5;52m"
export MEDIUMGREY_BG="\\033[48;5;246m"
export MEDIUMGREY="\\033[38;5;246m"
export MINTGREEN_BG="\\033[48;5;121m"
export MINTGREEN="\\033[38;5;121m"
export NC="\033[0m"
export ORANGE_BG="\\033[48;5;203m"
export ORANGE="\\033[38;5;203m"
export PINK_BG="\\033[48;5;211m"
export PINK="\\033[38;5;211m"
export RED="\033[0;31m"
export SKYBLUE_BG="\\033[48;5;111m"
export SKYBLUE="\\033[38;5;111m"
export TAN_BG="\\033[48;5;179m"
export TAN="\\033[38;5;179m"
export UNDERLINE="\\033[4m"
export WHITE="\033[1;37m"

export COLORS=(
    BLUE
    BOLD
    FOREST
    FOREST_BG
    GRAY
    GREEN
    HOTPINK
    HOTPINK_BG
    JADE
    JADE_BG
    LAVENDER
    LAVENDER_BG
    LIGHT_GRAY
    LIGHT_RED
    LIGHTORANGE
    LIGHTORANGE_BG
    LIGHTRED
    LIGHTRED_BG
    LIME
    LIME_BG
    MAROON
    MAROON_BG
    MEDIUMGREY
    MEDIUMGREY_BG
    MINTGREEN
    MINTGREEN_BG
    ORANGE
    ORANGE_BG
    PINK
    PINK_BG
    RED
    SKYBLUE
    SKYBLUE_BG
    TAN
    TAN_BG
    UNDERLINE
    WHITE
)

eval $(thefuck --alias)
