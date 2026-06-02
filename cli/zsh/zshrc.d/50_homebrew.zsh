[[ "$DOTFILES_OS" != "darwin" ]] && return

export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export HOMEBREW_DISPLAY_INSTALL_TIMES=true
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_UPGRADE_GREEDY=true
export LDFLAGS="-L /opt/homebrew/opt/libpq/lib"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/opt/libpq/bin"
export PATH="$PATH:/opt/homebrew/opt/node@22/bin"
export PATH="$PATH:/opt/homebrew/share/google-cloud-sdk/bin"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
