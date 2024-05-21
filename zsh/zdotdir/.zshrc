$SHELL_DEBUG && echo "👾 zshrc"

# profiling shell
if $SHELL_PROFILE; then
    [ ! -d "$SHELL_SESSION_PATH" ] && mkdir -p "$SHELL_SESSION_PATH"
    zmodload zsh/zprof
    $SHELL_DEBUG && echo "a zsh profile was started"
fi

disable log &>/dev/null && function log() {
    for f in "${DOTFILES}"/zsh/functions/log*; do
        # shellcheck source=/dev/null
        . "$f"
    done
    # shellcheck disable=SC2294
    eval log "$@"
}

log start "zshrc"

# shellcheck disable=SC2168
local inits=()

# shellcheck disable=SC2030
# shellcheck disable=SC2086
find ${DOTFILES}/ -maxdepth 3 -type f -path '*/init.d/*' | sort \
    | while IFS="" read -r line; do inits+=("$line"); done

# shellcheck disable=SC2030
# shellcheck disable=SC2031
# shellcheck disable=SC2086
find ${SYNC_DOTFILES}/ -maxdepth 3 -type f -path '*/init.d/*' | sort \
    | while IFS="" read -r line; do inits+=("$line"); done
# inits+=($(find ${SYNC_DOTFILES}/ -maxdepth 3 -type f -path '*/init.d/*' | sort))

startList=$(date +%s%N)
# shellcheck disable=SC2031
# shellcheck disable=SC2168
local _init_order=(
    "${DOTFILES}/zsh/functions/elapsed_time"
    "${DOTFILES}/ubuntu/start"
    "${DOTFILES}/zsh/start"
    "${DOTFILES}/ssh/start"
    # "${DOTFILES}/antigen/start"
    "${DOTFILES}/zplug/functions/zplug_reset"
    "${DOTFILES}/zplug/start"
    "${DOTFILES}/ohmyzsh/start"
    # "${DOTFILES}/starship/start"
    "${DOTFILES}/powerline/start"
    # "${DOTFILES}/tabby/start"
    "${DOTFILES}/dropbox/start"
    # "${DOTFILES}/vscode-server/start"
    "${DOTFILES}/aliases"
    "${inits[@]}"
); for _f in "${_init_order[@]}"; do
    startFile=$(date +%s%N)
    # shellcheck source=/dev/null
    . "$_f"
    # shellcheck disable=SC2086
    $SHELL_DEBUG && echo "$(elapsed_time ${startFile}) $_f"
done
# shellcheck disable=SC2086
$SHELL_DEBUG && echo "$(elapsed_time ${startList}) everything"

log finish "zshrc"

# profiling shell
if $SHELL_PROFILE; then
    zprof > "${SHELL_SESSION_PATH}/${NOW}.prf"
    echo "a log profile file as created here ${SHELL_SESSION_PATH}/${NOW}.prf"
fi
