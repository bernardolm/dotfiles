[[ "$DOTFILES_OS" = "darwin" ]] || return

alias brew-upgrade='brew update --quiet && brew upgrade --quiet --greedy'

export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export HOMEBREW_DISPLAY_INSTALL_TIMES=true
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_UPGRADE_GREEDY=true
export LDFLAGS="-L /opt/homebrew/opt/libpq/lib"
export PATH="$PATH:/opt/homebrew/opt/libpq/bin:/opt/homebrew/bin"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
