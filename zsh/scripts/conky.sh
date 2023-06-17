#!/usr/bin/env zsh

fpath=( "${DOTFILES}/zsh/functions" $fpath )
autoload -Uz "${fpath[1]}"/*(:t)

todo_conky $@
