export EDITOR=nano
export LANG=en_US.UTF-8

export DOTFILES
DOTFILES="$HOME/workspaces/bernardolm/dotfiles"

export SYNC_DOTFILES
SYNC_DOTFILES="$HOME/sync"

export USER_TMP
USER_TMP=$(mktemp -d)

export PATH=$PATH:/bin
export PATH=$PATH:/snap/bin/
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/java/jre/bin
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$SYNC_DOTFILES/bin

export EMOJI_CLI_KEYBIND="^e"
