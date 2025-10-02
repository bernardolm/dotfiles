$SHELL_DEBUG && echo ".zprofile"

mkdir -m u=rwX,g=rX -p \
	"$DOTFILES/git/modules" \
	"$ELAPSED_TIME_ROOT" \
	"$GOPATH" \
	"$HOME/.local/bin" \
	"$USER_TMP" \
	"$WORKSPACE_ORG" \
	"$WORKSPACE_USER" \
  "$HOME/sync/linux/crontab/"
