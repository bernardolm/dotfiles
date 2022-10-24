export EDITOR=nano

export USER_TMP=$(mktemp -d)

[ -d "$HOME/Sync/config-backup" ] && export SYNC_PATH=$HOME/Sync/config-backup

# Workspaces (at this point, isn't exist workspaces envs exported)
export GITHUB_USER
GITHUB_USER=$(git config --file "$SYNC_PATH/.gitconfig" github.user)
export GITHUB_ORG
GITHUB_ORG=$(git config --file "$SYNC_PATH/.gitconfig" github.organization)

[ -n "$GITHUB_ORG" ] && export GOPRIVATE="github.com/$GITHUB_ORG/*"

[ -d "$HOME/workspaces/$GITHUB_USER" ] && export WORKSPACE_USER=$HOME/workspaces/$GITHUB_USER
[ -n "$WORKSPACE_USER" ] && export DOTFILES=$WORKSPACE_USER/dotfiles

[ -d "$HOME/workspaces/$GITHUB_ORG" ] && export WORKSPACE_ORG=$HOME/workspaces/$GITHUB_ORG

[ ! -d "$WORKSPACE_USER" ] && mkdir -p "$WORKSPACE_USER"
[ ! -d "$WORKSPACE_ORG" ] && mkdir -p "$WORKSPACE_ORG"

[ -d "$HOME/gopath" ] && export GOPATH=$HOME/gopath

export PATH=$PATH:/bin
export PATH=$PATH:/snap/bin/
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/java/jre/bin
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.zinit/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$SYNC_PATH/bin

export ZINIT_ROOT="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
export ZSH="$ZINIT_ROOT/plugins/ohmyzsh---ohmyzsh"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'

export STARSHIP_CONFIG="$DOTFILES/starship/pastel-powerline.toml"
