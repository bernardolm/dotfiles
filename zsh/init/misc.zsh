eval "$(thefuck --yeah --alias)"

eval "$(starship init zsh)"

eval "$(op completion zsh)"
compdef _op op

source "$HOME/.cargo/env"

source "$DOTFILES/zsh/conky.zsh"
conky_restart

if [[ `uname` == Linux ]] then
    _warn "asking for password for keychan"
    eval "$(/usr/bin/keychain --quiet --eval $HOME/.ssh/id_ed25519)"
    source $HOME/.keychain/$HOST-sh
fi

export GPG_TTY=$(tty)
