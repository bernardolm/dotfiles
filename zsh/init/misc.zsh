LANG="pt_BR.utf8"
export LANG
$DEBUG_SHELL && localectl status

eval "$(op completion zsh)" && compdef _op op
eval "$(thefuck --yeah --alias)"
source "$DOTFILES/zsh/conky.zsh" && conky_restart
source "$HOME/.cargo/env"
