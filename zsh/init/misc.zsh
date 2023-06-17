$SHELL_DEBUG && localectl status

(conky_restart &)

command -v op >/dev/null && eval "$(op completion zsh)" && compdef _op op
command -v thefuck >/dev/null && eval "$(thefuck --yeah --alias)"

[ -f "${HOME}/.cargo/env" ] && . "${HOME}/.cargo/env"
[ -f "${HOME}/.fzf.zsh" ] && . "${HOME}/.fzf.zsh"

hudctl_completion='/usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash'
# shellcheck source=/dev/null
[ -f ${hudctl_completion} ] && . "${hudctl_completion}"

disable_accelerometter &>/dev/null && disable_accelerometter

if [ command -v docker &>/dev/null ] && [ $(cat /etc/group | grep -c docker) -gt 0 ]; then
    echo "if it asks for a password\nit's because your user\ndoesn't belong to the docker group yet."
    echo "you needs to run '${DOTFILES}/docker/install' first."
    newgrp docker
fi

chrome_bookmarks_backup

[ ! -d "${SYNC_DOTFILES}/gnome_shell_extensions" ] && \
    mkdir -p "${SYNC_DOTFILES}/gnome_shell_extensions"

echo '{"x":'$(gsettings get org.gnome.shell enabled-extensions)'}' | \
    tr "'" '"' | \
    jq '.x[]' | \
    tee "${SYNC_DOTFILES}/gnome_shell_extensions/${TIMESTAMP}.bkp" &>/dev/null
