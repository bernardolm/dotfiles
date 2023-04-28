# avoiding load again
[ ! -z "$DEBUG_SHELL" ] && return

export DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo "$DEBUG_SHELL")

export DEBUG_SHELL=true

# export DEBUG
# [ $DEBUG ] && set -x

. "$DOTFILES/zsh/functions/log.zsh"

$DEBUG_SHELL && _warn "running in DEBUG mode"

$DEBUG_SHELL && echo -e "debug: testing emoji char: \xee\x82\xa0 \xf0\x9f\x90\x8d"
