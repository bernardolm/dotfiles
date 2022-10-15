#!/usr/bin/env zsh

function notice() {
    test -z "${NC}" && echo "💬 $@" || echo "💬 ${CYAN}$@${NC}"
}
function warn() {
    test -z "${NC}" && echo "🚧 $@" || echo "🚧 ${RED}$@${NC}"
}

export DOTFILES
DOTFILES=$(dirname "$0")

find "$DOTFILES/init" -name '*.zsh' | sort | while read -r file ; do
    $DEBUG_SHELL && notice "loading ${file}"
    source "${file}"
done

find "$DOTFILES" -name '*.zsh' | grep -v "/init/" | while read -r file ; do
    $DEBUG_SHELL && notice "loading ${file}"
    source "${file}"
done

find "$DOTFILES" -name 'aliases' | grep -v "/init/" | while read -r file ; do
    $DEBUG_SHELL && notice "loading ${file}"
    source "${file}"
done

[ -f /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash ] &&
    source /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash

command -v disable_accelerometter &>/dev/null && disable_accelerometter
