#!/usr/bin/env /bin/sh

if [ -f ~/.zshenv ]; then
	mv ~/.zshenv ~/.zshenv.bkp
fi

tee ~/.zshenv <<EOF

# echo "~/.zshenv"
export ZDOTDIR=$HOME/dotfiles/cli/zsh/zdotdir
. $ZDOTDIR/.zshenv

EOF
