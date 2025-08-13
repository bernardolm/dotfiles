docker run --rm -v "$HOME/sync/shared/fonts/nerd_in:/in:Z" -v "$HOME/sync/shared/fonts/nerd_out:/out:Z" -e "PN=1" nerdfonts/patcher --debug=2 --complete --dry --progressbars -ext ttf
