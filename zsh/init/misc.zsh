$SHELL_DEBUG && localectl status

command -v thefuck >/dev/null && \
    eval "$(thefuck --alias)"

[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
[ -f "${HOME}/.fzf.zsh" ] && . "${HOME}/.fzf.zsh"

if [ "$XDG_SESSION_TYPE" != "tty" ]; then
    (conky_restart &)

    [ ! -d "${SYNC_DOTFILES}/gnome_shell_extensions" ] && \
        mkdir -p "${SYNC_DOTFILES}/gnome_shell_extensions"

    if gsettings get org.gnome.shell enabled-extensions &>/dev/null; then
        echo '{"x":'$(gsettings get org.gnome.shell enabled-extensions)'}' | \
            tr "'" '"' | \
            jq '.x[]' | \
            tee "${SYNC_DOTFILES}/gnome_shell_extensions/${TIMESTAMP}.bkp" &>/dev/null
    fi
fi

bindkey "^s" emoji::cli
