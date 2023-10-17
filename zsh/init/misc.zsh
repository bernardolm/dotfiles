$SHELL_DEBUG && localectl status

command -v op >/dev/null && eval "$(op completion zsh)" && compdef _op op
command -v thefuck >/dev/null && eval "$(thefuck --yeah --alias)"

[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
[ -f "${HOME}/.fzf.zsh" ] && . "${HOME}/.fzf.zsh"

if command -v docker &>/dev/null && [ $(cat /etc/group | grep -c docker) -eq 0 ]; then
    echo "calling docker, if it asks for a password it's because your user doesn't belong to the docker group yet."
    echo "you needs to run '${DOTFILES}/docker/install' first."
    . "${DOTFILES}/docker/install"
fi

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

unset sudo
