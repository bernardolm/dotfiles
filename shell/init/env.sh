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

[ -d ~/workspaces/$GITHUB_ORG ] && export WORKSPACE_ORG=~/workspaces/$GITHUB_ORG

[ ! -d $WORKSPACE_USER ] && mkdir -p $WORKSPACE_USER
[ ! -d $WORKSPACE_ORG ] && mkdir -p $WORKSPACE_ORG

# [ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin:

[ -d ~/gopath ] && export GOPATH=~/gopath
# [ -d $GOPATH/bin ] && export PATH=$PATH:$GOPATH/bin:

[ -f $SYNC_PATH/aliases ] && (($DEBUG_SHELL && echo "loading sync path aliases in $SYNC_PATH/aliases") || true) && \
    source $SYNC_PATH/aliases
[ -f $DOTFILES/aliases ] && (($DEBUG_SHELL && echo "loading git path aliases in $DOTFILES/aliases") || true) && \
    source $DOTFILES/aliases

export PATH=$PATH:/bin:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.zinit/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$SYNC_PATH/bin
typeset -U PATH # Remove duplicates in $PATH

BLUE="\033[0;34m"
BOLD="\033[1m"
FOREST_BG="\\033[48;5;22m"
FOREST="\\033[38;5;22m"
GRAY="\033[0;37m"
GREEN="\033[0;32m"
HOTPINK_BG="\\033[48;5;198m"
HOTPINK="\\033[38;5;198m"
JADE_BG="\\033[48;5;35m"
JADE="\\033[38;5;35m"
LAVENDER_BG="\\033[48;5;183m"
LAVENDER="\\033[38;5;183m"
LIGHT_GRAY="\033[0;37m"
LIGHT_RED="\033[1;31m"
LIGHTORANGE_BG="\\033[48;5;215m"
LIGHTORANGE="\\033[38;5;215m"
LIGHTRED_BG="\\033[48;5;203m"
LIGHTRED="\\033[38;5;203m"
LIME_BG="\\033[48;5;154m"
LIME="\\033[38;5;154m"
MAROON_BG="\\033[48;5;52m"
MAROON="\\033[38;5;52m"
MEDIUMGREY_BG="\\033[48;5;246m"
MEDIUMGREY="\\033[38;5;246m"
MINTGREEN_BG="\\033[48;5;121m"
MINTGREEN="\\033[38;5;121m"
NC="\033[0m"
ORANGE_BG="\\033[48;5;203m"
ORANGE="\\033[38;5;203m"
PINK_BG="\\033[48;5;211m"
PINK="\\033[38;5;211m"
RED="\033[0;31m"
SKYBLUE_BG="\\033[48;5;111m"
SKYBLUE="\\033[38;5;111m"
TAN_BG="\\033[48;5;179m"
TAN="\\033[38;5;179m"
UNDERLINE="\\033[4m"
WHITE="\033[1;37m"

COLORS=(
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

if $DEBUG_SHELL; then
    for c in ${COLORS[@]}; do
        if [[ "$(ps -p $$ -ocomm=)" = "zsh" ]]; then
            printf "${(P)c} foobar ${NC}\n"
        else
            printf "${!c} foobar ${NC}\n"
        fi
    done
    echo "$NC"
fi
