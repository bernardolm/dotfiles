eval "$(thefuck --alias)"

eval "$(emplace init zsh)"
export EMPLACE_CONFIG="$DOTFILES/emplace.toml"
export EMPLACE_CONFIG_PATH="$DOTFILES"

eval "$(starship init zsh)"

# eval $(op signin my)
# op signin --list
