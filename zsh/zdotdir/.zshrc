$SHELL_DEBUG && echo "👾 zshrc"

disable log &>/dev/null

function log() {
    for f in $DOTFILES/zsh/functions/log*; do
        . $f
    done
    eval log $@
}

log start "zshrc"

# profiling shell
# Ref.: https://kevin.burke.dev/kevin/profiling-zsh-startup-time/
if [[ "${SHELL_PROFILE}" == "true" ]]; then
    [ ! -d "$SHELL_SESSION_PATH" ] && mkdir -p "$SHELL_SESSION_PATH"
    zmodload zsh/zprof
    exec 3>&2 2>"${SHELL_SESSION_PATH}/${NOW}.log"
    setopt xtrace prompt_subst
fi

# shellcheck source=/dev/null
. "${DOTFILES}/ubuntu/start"

# shellcheck source=/dev/null
. "${DOTFILES}/zsh/start"

# shellcheck source=/dev/null
. "${DOTFILES}/ssh/start"

# shellcheck source=/dev/null
# . "${DOTFILES}/antigen/start"

# shellcheck source=/dev/null
. "${DOTFILES}/zplug/start"

# shellcheck source=/dev/null
. "${DOTFILES}/ohmyzsh/start"

# shellcheck source=/dev/null
. "${DOTFILES}/ohmyzsh/start"

# shellcheck source=/dev/null
# . "${DOTFILES}/ohmyposh/start"

# shellcheck source=/dev/null
. "${DOTFILES}/tabby/start"

# shellcheck source=/dev/null
. "${DOTFILES}/starship/start"

# shellcheck source=/dev/null
# . "${DOTFILES}/dropbox/start"

iterate_and_load "dotfiles aliases" "$DOTFILES" "aliases" "sort"
iterate_and_load "sync path aliases" "$SYNC_DOTFILES" "aliases" "sort"

# profiling shell
if [[ "${SHELL_PROFILE}" == "true" ]]; then
    exec 2>&3 3>&-
    unsetopt xtrace
    zprof > "${SHELL_SESSION_PATH}/${NOW}.prf"
fi

log finish "zshrc"
