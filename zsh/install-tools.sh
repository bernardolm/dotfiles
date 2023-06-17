#!/usr/bin/env zsh

[ ! -f ~/.local/bin/dropbox.py ] && \
    curl -sL 'https://linux.dropbox.com/packages/dropbox.py' \
        -o ~/.local/bin/dropbox.py
    chmod u+x ~/.local/bin/dropbox.py

[ ! -f ~/.local/bin/gnome-shell-extension-installer ] && \
    curl -sL 'https://raw.githubusercontent.com/brunelli/' \
        'gnome-shell-extension-installer/master/' \
        'gnome-shell-extension-installer' \
        -o ~/.local/bin/gnome-shell-extension-installer && \
    chmod u+x ~/.local/bin/gnome-shell-extension-installer

[ ! -f ~/.local/bin/go-redis-migrate ] && \
    curl -sL 'https://github.com/obukhov/go-redis-migrate/releases/' \
        'download/v2.0/go-redis-migrate-v2-linux' \
        -o ~/.local/bin/go-redis-migrate && \
    chmod u+x ~/.local/bin/go-redis-migrate

[ ! -f ~/.local/bin/slugify ] && \
    curl -sL 'https://raw.githubusercontent.com/benlinton/slugify/master/slugify' \
        -o ~/.local/bin/slugify && \
    chmod u+x ~/.local/bin/slugify

[ ! -f ~/.local/bin/theme.sh ] && \
    curl -sL 'https://git.io/JM70M' -o ~/.local/bin/theme.sh && \
    chmod u+x ~/.local/bin/theme.sh

[ ! -f ~/.local/bin/revolver ] && \
    curl -sL 'https://raw.githubusercontent.com/molovo/revolver/master/revolver' \
        -o ~/.local/bin/revolver && \
    chmod u+x ~/.local/bin/revolver

[ ! -f ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ] && \
    curl -sL 'https://github.com/powerline/powerline/raw/master/font/10-powerline-symbols.conf' \
        -o ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
