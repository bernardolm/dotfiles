SPACESHIP_RANDOM_EMOJI_SHOW="${SPACESHIP_RANDOM_EMOJI_SHOW=true}"

spaceship_random_emoji() {
    [[ $SPACESHIP_RANDOM_EMOJI_SHOW == false ]] && return
    spaceship::exists random_emoji || return
    local 'local_random_emoji'
    source $WORKSPACE_USER/first-steps-ubuntu/shell-scripts/random_emoji.sh
    emoji="$(random_emoji)"
    [[ -z $emoji ]] && return
    spaceship::section "" "$emoji "
}
