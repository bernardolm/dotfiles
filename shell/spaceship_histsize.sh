function spaceship_histsize() {
    # If SPACESHIP_HISTSIZE_SHOW is false, don't show HISTSIZE section
    [[ $SPACESHIP_HISTSIZE_SHOW == false ]] && return

    # Use quotes around unassigned local variables to prevent
    # getting replaced by global aliases
    # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
    local histfile_size=$([ -f $HISTFILE ] && echo -n $(wc -l <$HISTFILE))

    # Exit section if variable is empty
    [[ -z $histfile_size ]] && return

    export SPACESHIP_HISTSIZE_COLOR=${SPACESHIP_HISTSIZE_COLOR="white"}
    export SPACESHIP_HISTSIZE_SYMBOL=${SPACESHIP_HISTSIZE_SYMBOL=📜}

    # Display HISTSIZE section
    spaceship::section \
        "$SPACESHIP_HISTSIZE_COLOR" \
        "$SPACESHIP_HISTSIZE_PREFIX" \
        "${SPACESHIP_HISTSIZE_SYMBOL} ${histfile_size} " \
        "$SPACESHIP_HISTSIZE_SUFFIX"
}
