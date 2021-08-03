export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history
export HISTSIZE=99999
export SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
unsetopt HIST_SAVE_BY_COPY
