#!/usr/bin/env zsh

# /bin/rm -rf "${HOME}/.zsh"
# /bin/rm -rf "${HOME}/.oh-my-zsh"
# /bin/rm -rf "${HOME}/.oh-my-posh"
# /bin/rm -rf "${HOME}/.zplug"

# profiling shell
# Ref.: https://kevin.burke.dev/kevin/profiling-zsh-startup-time/
if [[ "$SHELL_PROFILE" == "true" ]]; then
    [ ! -d "$SHELL_SESSION_PATH" ] && mkdir -p "$SHELL_SESSION_PATH"
    zmodload zsh/zprof
    exec 3>&2 2>"${SHELL_SESSION_PATH}/${NOW}.log"
    setopt xtrace prompt_subst
fi

. "${DOTFILES}/ubuntu/install"

. "${DOTFILES}/zsh/start"
# . "${DOTFILES}/ohmyzsh/start"
# . "${DOTFILES}/starship/start"

# . "${DOTFILES}/antigen/start"
# . "${DOTFILES}/dropbox/start"
# . "${DOTFILES}/ohmyposh/start"
# . "${DOTFILES}/pretzo/start"
. "${DOTFILES}/zplug/start"

# profiling shell
if [[ "$SHELL_PROFILE" == "true" ]]; then
    exec 2>&3 3>&-
    unsetopt xtrace
    zprof > "${SHELL_SESSION_PATH}/${NOW}.prf"
fi
