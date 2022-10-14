# set -e # Exit after first error

[ $DEBUG ] && set -x

# DEBUG_SHELL=true

export DEBUG_SHELL
DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)

$DEBUG_SHELL && warn "running in DEBUG mode"
