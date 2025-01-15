zsh_history_source=/home/bernardo/Dropbox/linux/home/.zsh_history
zsh_history_target=/home/bernardo/.zsh_history

if [ ! -h "${zsh_history_target}" ]; then
    log info "fixing zsh history sym link"

    /bin/cat "${zsh_history_target}" >> "${zsh_history_source}"
    rm -f "${zsh_history_target}"
    ln -sf "${zsh_history_source}" "${zsh_history_target}"
fi
