[[ "$DOTFILES_OS" = "darwin" ]] || return

export HOMEBREW_DISPLAY_INSTALL_TIMES=true
export HOMEBREW_UPGRADE_GREEDY=true
alias brew-upgrade='brew update --quiet && brew upgrade --quiet --greedy'
