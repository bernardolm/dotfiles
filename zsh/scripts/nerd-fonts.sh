docker run --rm -v "$HOME/sync/shared/fonts/NovaMono:/in:Z" -v "$HOME/sync/shared/fonts/patched:/out:Z" -e "PN=10" nerdfonts/patcher -c -ext ttf
