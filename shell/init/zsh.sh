setopt extended_history
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
unsetopt hist_save_by_copy

[ ! $DEBUG_SHELL ] && setopt promptsubst

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk
export HISTSIZE=-1
export SAVEHIST=$HISTSIZE
