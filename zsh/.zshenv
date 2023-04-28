export CLICOLOR=true
export DOTFILES="$HOME/workspaces/bernardolm/dotfiles"
export EDITOR=nano
export EMOJI_CLI_KEYBIND="^e"
export GOPATH=$HOME/gopath
export GOROOT=/usr/local/go
export GPG_TTY=$(tty)
export LANG=en_US.UTF-8
export MICRO_TRUECOLOR=1
export SYNC_DOTFILES="$HOME/sync"
export TERM=xterm-256color
# export USER_TMP=$(mktemp -d)
export USER_TMP=$HOME/tmp

export GITHUB_ORG=$(git config --file "$SYNC_DOTFILES/.gitconfig_work" github.organization)
export GITHUB_USER=$(git config --file "$DOTFILES/.gitconfig" github.user)

export WORKSPACE_ORG="$HOME/workspaces/$GITHUB_ORG"
export WORKSPACE_USER="$HOME/workspaces/$GITHUB_USER"

export PATH=$PATH:/bin
export PATH=$PATH:/snap/bin/
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/java/jre/bin
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$SYNC_DOTFILES/bin
