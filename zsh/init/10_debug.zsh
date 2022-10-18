test -z "$debugfileloaded" || return 1
export debugfileloaded="yes"

function log() {
    local icon
    icon="$1"

    shift

    local color
    color="$1"

    shift

    test -z "${NC}" && echo "$icon $@" >&2 || echo "$icon ${color}$@${NC}" >&2
}

function notice() {
    log "💬" "$CYAN" "$@"
}

function warn() {
    log "🚧" "$RED" "$@"
}

# -e: exit on error
# -u: exit on unset variables
# set -eu

[ $DEBUG ] && set -x

# DEBUG_SHELL=true

export DEBUG_SHELL
DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)

$DEBUG_SHELL && warn "running in DEBUG mode"
