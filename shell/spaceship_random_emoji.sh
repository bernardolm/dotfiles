function spaceship_random_emoji() {
    # If SPACESHIP_RANDOM_EMOJI_SHOW is false, don't show RANDOM_EMOJI section
    [[ $SPACESHIP_RANDOM_EMOJI_SHOW == false ]] && return

    # Use quotes around unassigned local variables to prevent
    # getting replaced by global aliases
    # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
    local 'local_random_emoji'
    source $DOTFILES/shell/random_emoji.sh
    local emoji="$(random_emoji)"

    spaceship::exists random_emoji || return

    # Exit section if variable is empty
    [[ -z $emoji ]] && return

    export SPACESHIP_RANDOM_EMOJI_SHOW=${SPACESHIP_RANDOM_EMOJI_SHOW=true}

    # Display HISTSIZE section
    spaceship::section \
        "$SPACESHIP_RANDOM_EMOJI_COLOR" \
        "$SPACESHIP_RANDOM_EMOJI_PREFIX" \
        "${SPACESHIP_RANDOM_EMOJI_SYMBOL}${emoji} " \
        "$SPACESHIP_RANDOM_EMOJI_SUFFIX"
}
