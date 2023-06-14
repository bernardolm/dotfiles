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
