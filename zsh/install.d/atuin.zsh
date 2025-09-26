if [ ! $(command -v atuin &>/dev/null) ]; then
	curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
	[ -d $HOME/.config/atuin ] && rm -rf $HOME/.config/atuin 2>/dev/null
	ln -sf $HOME/sync/linux/home/.config/atuin $HOME/.config/atuin
	cat << EOF
> maybe, you need to register with:
> atuin register -u $GITHUB_USER -e $USER_EMAIL
> atuin key
> atuin import auto
> atuin sync"
EOF
fi
