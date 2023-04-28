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
    _echo "" "${RED}${ON_YELLOW}" "$@"
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
