eval "$(thefuck --yeah --alias)"

eval "$(starship init zsh)"

# eval $(op signin my)
# op signin --list

source "$HOME/.cargo/env"

source "$DOTFILES/zsh/conky.zsh"
conky_restart
