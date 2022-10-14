#!/usr/bin/env zsh

# set -e # Exit after first error

# DEBUG_SHELL=true
[ $DEBUG ] && set -x

export DEBUG_SHELL
DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)
$DEBUG_SHELL && echo "\033[1;31m📢 📢 📢 running in DEBUG mode\033[0m\n"

export DOTFILES
DOTFILES=$(dirname "$0")
$DEBUG_SHELL && echo "dotfiles based in $DOTFILES"

find "$DOTFILES/init" -name '*.zsh' | sort | while read -r file ; do
    $DEBUG_SHELL && echo "loading ${file}"
    source "${file}"
done

find "$DOTFILES" -name '*.zsh' | grep -v "/init/" | while read -r file ; do
    $DEBUG_SHELL && echo "loading ${file}"
    source "${file}"
done

source "$DOTFILES/aliases"

[ -f /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash ] &&
    source /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash

[ $(command -v disable_accelerometter) ] && disable_accelerometter

eval $(dircolors "$HOME/.dir_colors")
