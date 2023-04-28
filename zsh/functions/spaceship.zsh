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
    export SPACESHIP_HISTSIZE_PREFIX=${SPACESHIP_HISTSIZE_PREFIX=""}
    export SPACESHIP_HISTSIZE_SHOW=${SPACESHIP_HISTSIZE_SHOW=true}
    export SPACESHIP_HISTSIZE_SUFFIX=${SPACESHIP_HISTSIZE_SUFFIX=" "}
    export SPACESHIP_HISTSIZE_SYMBOL=${SPACESHIP_HISTSIZE_SYMBOL=📜}

    # Display HISTSIZE section
    spaceship::section::v4 \
        --color "$SPACESHIP_HISTSIZE_COLOR" \
        --prefix "$SPACESHIP_HISTSIZE_PREFIX" \
        --suffix "$SPACESHIP_HISTSIZE_SUFFIX" \
        --symbol "$SPACESHIP_HISTSIZE_SYMBOL " \
        "$histfile_size"
}

function spaceship_random_emoji() {
    # If SPACESHIP_RANDOM_EMOJI_SHOW is false, don't show RANDOM_EMOJI section
    [[ $SPACESHIP_RANDOM_EMOJI_SHOW == false ]] && return

    # Use quotes around unassigned local variables to prevent
    # getting replaced by global aliases
    # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
    source $DOTFILES/zsh/random_emoji.zsh
    local emoji="$(random_emoji)"

    spaceship::exists random_emoji || return

    # Exit section if variable is empty
    [[ -z $emoji ]] && return

    export SPACESHIP_RANDOM_EMOJI_COLOR=${SPACESHIP_RANDOM_EMOJI_COLOR="white"}
    export SPACESHIP_RANDOM_EMOJI_PREFIX=${SPACESHIP_RANDOM_EMOJI_PREFIX=""}
    export SPACESHIP_RANDOM_EMOJI_SHOW=${SPACESHIP_RANDOM_EMOJI_SHOW=true}
    export SPACESHIP_RANDOM_EMOJI_SUFFIX=${SPACESHIP_RANDOM_EMOJI_SUFFIX=" "}
    export SPACESHIP_RANDOM_EMOJI_SYMBOL=${SPACESHIP_RANDOM_EMOJI_SYMBOL=$emoji}

    # Display RANDOM_EMOJI section
    spaceship::section::v4 \
        --color "$SPACESHIP_RANDOM_EMOJI_COLOR" \
        --prefix "$SPACESHIP_RANDOM_EMOJI_PREFIX" \
        --suffix "$SPACESHIP_RANDOM_EMOJI_SUFFIX" \
        --symbol "$SPACESHIP_RANDOM_EMOJI_SYMBOL"
}
