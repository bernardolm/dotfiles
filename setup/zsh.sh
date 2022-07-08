setopt autocd
setopt beep
setopt extended_history
setopt extendedglob
setopt hist_ignore_dups
setopt inc_append_history
setopt nomatch
setopt notify
setopt share_history
unsetopt hist_save_by_copy

[ ! $DEBUG_SHELL ] && setopt promptsubst

export SAVEHIST=999999

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk
export HISTSIZE=$SAVEHIST

bindkey -e

zstyle :compinstall filename '/home/ubuntu/.zshrc'

autoload -Uz compinit
compinit
