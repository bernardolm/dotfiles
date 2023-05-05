#!/usr/bin/env zsh

autoload -Uz +X bashcompinit; bashcompinit
autoload -Uz +X colors; colors
autoload -Uz +X compinit; compinit
autoload -Uz +X promptinit; promptinit

# profiling shell
# Ref.: https://kevin.burke.dev/kevin/profiling-zsh-startup-time/
[ ! -d "$SHELL_SESSION_PATH" ] && mkdir -p "$SHELL_SESSION_PATH"

if [[ "$SHELL_PROFILE" == true ]]; then
    zmodload zsh/zprof
    exec 3>&2 2>"$SHELL_SESSION_PATH/${NOW}.log"
    # setopt xtrace
fi

fpath=( "$DOTFILES/zsh/functions" $fpath )
autoload -Uz ${fpath[1]}/*(:t)

iterate_and_load "dotfiles zsh init" "$DOTFILES/zsh/init" "*.zsh" "sort"
# iterate_and_load "dotfiles zsh functions" "$DOTFILES/zsh/functions" "*.zsh" "sort"
iterate_and_load "dotfiles aliases" "$DOTFILES" "aliases" "sort"
iterate_and_load "sync zsh init" "$SYNC_DOTFILES/zsh/init" "*.zsh" "sort"
# iterate_and_load "sync zsh functions" "$SYNC_DOTFILES/zsh/functions" "*.zsh" "sort"
iterate_and_load "sync path aliases" "$SYNC_DOTFILES" "aliases" "sort"

# profiling shell
if [[ "$SHELL_PROFILE" == true ]]; then
    # unsetopt xtrace
    zprof > "$SHELL_SESSION_PATH/${NOW}.prf"
fi
