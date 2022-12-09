function _echo() {
    local icon
    icon="$1"

    shift

    local color
    color="$1"

    shift

    test -z "${NC}" && echo "$icon $@" >&2 || echo "$icon ${color}$@${NC}" >&2
}

function _info() {
    _echo "💬" "$CYAN" "$@"
}

function _warn() {
    _echo "🚧" "$RED" "$@"
}

function _is_command_success() {
    if [ $? -eq 0 ]; then
        _echo "😉"
    else
        _echo "🤬"
    fi
}

function _starting() {
    _echo "🥚" "$GREEN" "starting $@..."
}


function _finishing() {
    _echo "🦖" "$RED" "$@ was finished."
}

# -e: exit on error
# -u: exit on unset variables
# set -eu

[ $DEBUG ] && set -x

# DEBUG_SHELL=true

export DEBUG_SHELL
DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)

$DEBUG_SHELL && _warn "running in DEBUG mode"
