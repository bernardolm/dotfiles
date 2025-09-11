if [ ! $(command -v atuin &>/dev/null) ]; then
	curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
	[ -d ~/.config/atuin ] && rm -rf ~/.config/atuin 2>/dev/null
	ln -sf ~/sync/linux/home/.config/atuin ~/.config/atuin
	echo "> maybe, you need to register with:\n> atuin register -u $GITHUB_USER -e $USER_EMAIL && atuin key && atuin import auto"
fi