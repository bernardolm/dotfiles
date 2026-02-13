docker run --rm -v "$HOME/Downloads/fonts-in:/in:Z" -v "$HOME/Downloads/fonts-out:/out:Z" -e "PN=1" nerdfonts/patcher --debug=2 --complete --progressbars -ext ttf
