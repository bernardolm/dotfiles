function _echo() {
    local icon
    icon="$1"

    shift

    local color
    color="$1"

    shift

    test -z "${NC}" && echo "$icon $@" >&2 || echo "$icon ${color}$@${NC}" >&2
}

function _debug() {
    _echo "" "$MINTGREEN" "$@"
}

function _info() {
    _echo "💬" "$CYAN" "$@"
}

function _warn() {
    _echo "🚧" "$YELLOW" "$@"
}

function _is_command_success() {
    if [ $? -eq 0 ]; then
        _echo "😉"
    else
        _echo "🤬"
    fi
}

function _starting() {
    _echo "🥚" "$PURPLE" "starting $@..."
}


function _finishing() {
    _echo "🦖" "$PURPLE" "$@ was finished."
}

export DEBUG_SHELL
DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)

# export DEBUG_SHELL=true

export DEBUG
[ $DEBUG ] && set -x

$DEBUG_SHELL && _warn "running in DEBUG mode"

$DEBUG_SHELL && echo -e "debug: testing emoji char: \xee\x82\xa0 \xf0\x9f\x90\x8d"
