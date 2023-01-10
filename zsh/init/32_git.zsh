export GITHUB_USER
GITHUB_USER=$(git config --file "$DOTFILES/.gitconfig" github.user)

export WORKSPACE_USER="$HOME/workspaces/$GITHUB_USER"
[ ! -d "$WORKSPACE_USER" ] && mkdir -p "$WORKSPACE_USER"

export GITHUB_ORG
GITHUB_ORG=$(git config --file "$SYNC_DOTFILES/.gitconfig_work" github.organization)

export WORKSPACE_ORG="$HOME/workspaces/$GITHUB_ORG"
[ ! -d "$WORKSPACE_ORG" ] && mkdir -p "$WORKSPACE_USER"

export GPG_TTY=$(tty)
