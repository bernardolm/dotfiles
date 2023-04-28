export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE="$SYNC_DOTFILES/.zsh_history" # Where to save history to disk
export HISTSIZE="$SAVEHIST"
export SAVEHIST=999999
export ZSH_WAKATIME_PROJECT_DETECTION=true

$DEBUG_SHELL || setopt PROMPT_SUBST # if is set, the prompt string is first subjected to parameter expansion, command substitution and arithmetic expansion.

setopt APPEND_HISTORY # add cmd to history, don't replace. to share history across sessions.
setopt AUTO_CD # exec cd if cmd is a folder.
setopt BEEP # beep on error in zle.
setopt COMPLETE_ALIASES # prevents aliases on the command line from being internally substituted before completion is attempted. the effect is to make the alias a distinct command for completion purposes.
setopt COMPLETE_IN_WORD # do not go to the end of the word in the completing
setopt CORRECT # try to correct the spelling of commands
setopt EXTENDED_HISTORY # add timestamps to history
setopt EXTENDEDGLOB # treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
setopt HIST_IGNORE_ALL_DUPS # remove old entry when an already existing cmd is added
setopt HIST_IGNORE_DUPS # do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_REDUCE_BLANKS # remove superfluous blanks from each command line being added to the history list.
setopt HIST_SAVE_BY_COPY # when the history file is re-written, we normally write out a copy of the file named $histfile.new and then rename it over the old one.
setopt HIST_VERIFY # whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt IGNORE_EOF # do not exit on end-of-file. require the use of exit or logout instead
setopt INC_APPEND_HISTORY # this option works like append_history except that new history lines are added to the $histfile incrementally (as soon as they are entered), rather than waiting until the shell exits
setopt LIST_BEEP # beep on an ambiguous completion.
setopt PROMPT_SUBST # if set, parameter expansion, command substitution and arithmetic expansion are performed in prompts
setopt SHARE_HISTORY # this option both imports new commands from the history file, and also causes your typed commands to be appended to the history file
unsetopt CORRECT_ALL # try to correct the spelling of arguments too
unsetopt HUP # don't kill bg process when terminal is killed or exited
unsetopt NOMATCH # if a pattern for filename generation has no matches, print an error
unsetopt NOTIFY # report the status of background jobs immediately,

# Ref.: https://zsh.sourceforge.io/Doc/Release/Options.html

if [ -n "${ZSH_VERSION}" ]; then
    autoload -U bashcompinit
    bashcompinit
fi

. "$DOTFILES/antigen/start"
# . "$DOTFILES/zplug/start"

. "$DOTFILES/ohmyzsh/start"
# . "$DOTFILES/ohmyposh/start"
