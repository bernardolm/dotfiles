export HISTFILE=$SYNC_PATH/.zsh_history # Where to save history to disk

export HISTDUP=erase # Erase duplicates in the history file
export HISTFILE=$SYNC_PATH/.zsh_history
export HISTSIZE=99999
export SAVEHIST=$HISTSIZE

setopt extended_history
setopt inc_append_history
setopt share_history
unsetopt hist_save_by_copy
setopt hist_ignore_dups

ZSH_THEME="spaceship"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none

for dir in /home/bernardo/.zinit/plugins/zsh* ; do
    zsh_plugin_name=("${(@s/---/)dir}")

    init_file=$dir/${zsh_plugin_name[2]}.zsh
    init_file_plugin=$dir/${zsh_plugin_name[2]}.plugin.zsh

    if [ -f "$init_file" ]; then
        source $init_file
    elif [ -f "$init_file_plugin" ]; then
        source $init_file_plugin
    else
        ll $dir
    fi
done
