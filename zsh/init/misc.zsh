# return

$SHELL_DEBUG && localectl status

(conky_restart &)

command -v op >/dev/null && eval "$(op completion zsh)" && compdef _op op
command -v thefuck >/dev/null && eval "$(thefuck --yeah --alias)"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"

hudctl_completion='/usr/local/lib'
hudctl_completion+='/node_modules/hudctl/completion'
hudctl_completion+='/hudctl-completion.bash'
# shellcheck source=/dev/null
[ -f ${hudctl_completion} ] && . "${hudctl_completion}"

disable_accelerometter &>/dev/null && disable_accelerometter

[ $(cat /etc/group | grep -c docker) -gt 0 ] && newgrp docker

chrome_bookmarks_backup

[ ! -f ~/.local/bin/dropbox.py ] && \
    curl -sL https://linux.dropbox.com/packages/dropbox.py -o ~/.local/bin/dropbox.py

[ ! -f ~/.local/bin/gnome-shell-extension-installer ] && \
    curl -sL https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer \
    -o ~/.local/bin/gnome-shell-extension-installer && \
    chmod +x ~/.local/bin/gnome-shell-extension-installer

[ ! -f ~/.local/bin/go-redis-migrate ] && \
    curl -sL https://github.com/obukhov/go-redis-migrate/releases/download/v2.0/go-redis-migrate-v2-linux \
    -o ~/.local/bin/go-redis-migrate && \
    chmod +x ~/.local/bin/go-redis-migrate

[ ! -f ~/.local/bin/slugify ] && \
    curl -sL https://raw.githubusercontent.com/benlinton/slugify/master/slugify \
    -o ~/.local/bin/slugify && \
    chmod +x ~/.local/bin/slugify

[ ! -f ~/.local/bin/theme.sh ] && \
    curl -sL https://git.io/JM70M -o ~/.local/bin/theme.sh && \
    chmod +x ~/.local/bin/theme.sh
