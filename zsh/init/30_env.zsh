export EDITOR=nano
export LANG=en_US.UTF-8

export USER_TMP=$(mktemp -d)

[ -d "$HOME/Sync/config-backup" ] && \
    export SYNC_PATH=$HOME/Sync/config-backup

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
export PATH=$PATH:$SYNC_PATH/bin

export EMOJI_CLI_KEYBIND="^e"
