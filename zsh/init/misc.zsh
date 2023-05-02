$DEBUG_SHELL && localectl status

(source "$DOTFILES/zsh/functions/conky.zsh" && conky_restart &)

eval "$(op completion zsh)" && compdef _op op
eval "$(thefuck --yeah --alias)"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

hudctl_completion='/usr/local/lib'
hudctl_completion+='/node_modules/hudctl/completion'
hudctl_completion+='/hudctl-completion.bash'
# shellcheck source=/dev/null
[ -f ${hudctl_completion} ] && source "${hudctl_completion}"

command -v disable_accelerometter &>/dev/null && disable_accelerometter

newgrp docker
