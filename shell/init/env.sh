export TERM=xterm-256color # for common 256 color terminals (e.g. gnome-terminal)
export USER_TMP=$HOME/tmp

[ -d $HOME/Sync/config-backup ] && export SYNC_PATH=$HOME/Sync/config-backup
[ -d $SYNC_PATH/bin ] && export PATH=$PATH:$SYNC_PATH/bin:

# Workspaces (at this point, isn't exist workspaces envs exported)
export GITHUB_USER=$(git config github.user)
export GITHUB_ORG=$(git config github.organization)

[ ! -z $GITHUB_ORG ] && export GOPRIVATE=github.com/$GITHUB_ORG/*

[ -d ~/workspaces/$GITHUB_USER ] && export WORKSPACE_USER=~/workspaces/$GITHUB_USER
[ ! -z $WORKSPACE_USER ] && export DOTFILES=$WORKSPACE_USER/dotfiles

[ -d ~/workspaces/$GITHUB_ORG ] && export WORKSPACE_ORG=~/workspaces/$GITHUB_ORG

[ ! -d $WORKSPACE_USER ] && mkdir -p $WORKSPACE_USER
[ ! -d $WORKSPACE_ORG ] && mkdir -p $WORKSPACE_ORG

[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin:

[ -d ~/gopath ] && export GOPATH=~/gopath
[ -d $GOPATH/bin ] && export PATH=$PATH:$GOPATH/bin:

[ -f $SYNC_PATH/aliases ] && (($DEBUG && echo "loading sync path aliases") || true) && \
    source $SYNC_PATH/aliases
[ -f $DOTFILES/aliases ] && (($DEBUG && echo "loading git path aliases") || true) && \
    source $DOTFILES/aliases

export GREP_OPTIONS='—color=auto'
