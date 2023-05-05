return

$SHELL_DEBUG && localectl status

(. "$DOTFILES/zsh/functions/conky.zsh" && conky_restart &)

eval "$(op completion zsh)" && compdef _op op
eval "$(thefuck --yeah --alias)"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"

hudctl_completion='/usr/local/lib'
hudctl_completion+='/node_modules/hudctl/completion'
hudctl_completion+='/hudctl-completion.bash'
# shellcheck source=/dev/null
[ -f ${hudctl_completion} ] && . "${hudctl_completion}"

disable_accelerometter &>/dev/null && disable_accelerometter

newgrp docker
