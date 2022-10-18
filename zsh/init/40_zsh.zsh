setopt autocd
setopt beep
setopt extended_history
setopt extendedglob
setopt hist_ignore_dups
setopt inc_append_history
setopt nomatch
setopt notify
setopt share_history
unsetopt correct
unsetopt hist_save_by_copy

$DEBUG_SHELL || setopt promptsubst

export SAVEHIST=999999

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk
export HISTSIZE=$SAVEHIST

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
# setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey -e
