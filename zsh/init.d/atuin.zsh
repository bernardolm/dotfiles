if [ ! $(atuin account verify &>/dev/null) ]; then
	atuin login -u $GITHUB_USER 1>/dev/null
	atuin sync 1>/dev/null
else
	atuin daemon 1>/dev/null &
fi
