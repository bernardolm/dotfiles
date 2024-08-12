#!/usr/bin/env zsh

docker run --rm -v "$HOME/shared/fonts/NovaMono:/in:Z" -v "$HOME/shared/fonts/patched:/out:Z" -e "PN=10" nerdfonts/patcher -c -ext ttf
