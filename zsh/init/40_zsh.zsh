export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE="$SYNC_DOTFILES/.zsh_history" # Where to save history to disk
export HISTSIZE="$SAVEHIST"
export SAVEHIST=999999

$SHELL_DEBUG || setopt prompt_subst # if is set, the prompt string is first subjected to parameter expansion, command substitution and arithmetic expansion.

setopt append_history # add cmd to history, don't replace. to share history across sessions.
setopt auto_cd # exec cd if cmd is a folder.
setopt beep # beep on error in zle.
setopt complete_aliases # prevents aliases on the command line from being internally substituted before completion is attempted. the effect is to make the alias a distinct command for completion purposes.
setopt complete_in_word # do not go to the end of the word in the completing
setopt correct # try to correct the spelling of commands
setopt extended_history # add timestamps to history
setopt extendedglob # treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
setopt hist_ignore_all_dups # remove old entry when an already existing cmd is added
setopt hist_ignore_dups # do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_reduce_blanks # remove superfluous blanks from each command line being added to the history list.
setopt hist_save_by_copy # when the history file is re-written, we normally write out a copy of the file named $histfile.new and then rename it over the old one.
setopt hist_verify # whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt ignore_eof # do not exit on end-of-file. require the use of exit or logout instead
setopt inc_append_history # this option works like append_history except that new history lines are added to the $histfile incrementally (as soon as they are entered), rather than waiting until the shell exits
setopt list_beep # beep on an ambiguous completion.
setopt prompt_subst # if set, parameter expansion, command substitution and arithmetic expansion are performed in prompts
setopt share_history # this option both imports new commands from the history file, and also causes your typed commands to be appended to the history file

setopt hist_expire_dups_first # Expire A duplicate event first when trimming history.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_space      # Do not record an Event Starting With A Space.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.

unsetopt correct_all # try to correct the spelling of arguments too
unsetopt hup # don't kill bg process when terminal is killed or exited
unsetopt nomatch # if a pattern for filename generation has no matches, print an error
unsetopt notify # report the status of background jobs immediately,

# Ref.: https://zsh.sourceforge.io/Doc/Release/Options.html

# . "$DOTFILES/antigen/start"
# . "$DOTFILES/zplug/start"
# . "$DOTFILES/pretzo/start"

. "$DOTFILES/ohmyzsh/start"
# . "$DOTFILES/ohmyposh/start"
