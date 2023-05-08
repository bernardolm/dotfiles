#!/usr/bin/env zsh

# rm -rf $HOME/.zsh
# rm -rf $HOME/.oh-my-zsh

# profiling shell
# Ref.: https://kevin.burke.dev/kevin/profiling-zsh-startup-time/
[ ! -d "$SHELL_SESSION_PATH" ] && mkdir -p "$SHELL_SESSION_PATH"
if [[ "$SHELL_PROFILE" == "true" ]]; then
    zmodload zsh/zprof
    exec 3>&2 2>"$SHELL_SESSION_PATH/${NOW}.log"
    setopt xtrace prompt_subst
fi

. $DOTFILES/zsh/start

# . "$DOTFILES/antigen/start"
# . "$DOTFILES/zplug/start"
# . "$DOTFILES/pretzo/start"

. "$DOTFILES/ohmyzsh/start"
. "$DOTFILES/ohmyposh/start"

zsh_plugins_load

# profiling shell
if [[ "$SHELL_PROFILE" == "true" ]]; then
    exec 2>&3 3>&-
    unsetopt xtrace
    zprof > "$SHELL_SESSION_PATH/${NOW}.prf"
fi
