eval "$(thefuck --yeah --alias)"

eval "$(starship init zsh)"

# eval $(op signin my)
# op signin --list

source "$HOME/.cargo/env"

source "$DOTFILES/zsh/conky.zsh"
conky_restart

if [[ `uname` == Linux ]] then
    eval "$(/usr/bin/keychain --quiet --eval $HOME/.ssh/id_ed25519)"
    source $HOME/.keychain/$HOST-sh
fi
