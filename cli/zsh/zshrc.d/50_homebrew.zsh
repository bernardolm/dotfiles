[[ "$DOTFILES_OS" != "darwin" ]] && return

export CPPFLAGS="-I /opt/homebrew/opt/curl/include $CPPFLAGS"
export CPPFLAGS="-I /opt/homebrew/opt/libpq/include $CPPFLAGS"
export CPPFLAGS="-I /opt/homebrew/opt/mysql-client/include $CPPFLAGS"
export CPPFLAGS="-I /opt/homebrew/opt/node@22/include $CPPFLAGS"
export HOMEBREW_DISPLAY_INSTALL_TIMES=true
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_REQUIRE_TAP_TRUST=1
export HOMEBREW_UPGRADE_GREEDY=true
export LDFLAGS="-L /opt/homebrew/opt/curl/lib $LDFLAGS"
export LDFLAGS="-L /opt/homebrew/opt/libpq/lib $LDFLAGS"
export LDFLAGS="-L /opt/homebrew/opt/mysql-client/lib $LDFLAGS"
export LDFLAGS="-L /opt/homebrew/opt/node@22/lib $LDFLAGS"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
export PKG_CONFIG_PATH=/opt/homebrew/opt/libpq/lib/pkgconfig

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
