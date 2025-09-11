if [ ! $(atuin account verify &>/dev/null) ]; then
	atuin login -u $GITHUB_USER 2>/dev/null
	atuin sync &>/dev/null
fi
