#!/usr/bin/env zsh

export DOTFILES
DOTFILES=$(dirname "$0")

source $DOTFILES/zsh/init/10_debug.zsh

find "$DOTFILES/zsh/init" -name '*.zsh' | sort | while read -r file; do
    $DEBUG_SHELL && _info "loading ${file}"
    source "${file}"
done

find "$SYNC_PATH/zsh/init" -name '*.zsh' | sort | while read -r file; do
    $DEBUG_SHELL && _info "loading ${file}"
    source "${file}"
done

find "$DOTFILES" -name '*.zsh' | grep -v "/init/" | while read -r file; do
    $DEBUG_SHELL && _info "loading ${file}"
    source "${file}"
done

find "$DOTFILES" -name 'aliases' | grep -v "/init/" | while read -r file; do
    $DEBUG_SHELL && _info "loading ${file}"
    source "${file}"
done

[ -f /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash ] &&
    source /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash

command -v disable_accelerometter &>/dev/null && disable_accelerometter
