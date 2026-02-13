if [ ! -d "$HOME/workspaces/misc/ohmyzsh" ] ; then
	git clone --quiet git@github.com:ohmyzsh/ohmyzsh.git "$HOME/workspaces/misc/ohmyzsh"
fi
source "$HOME/workspaces/misc/ohmyzsh/plugins/git/git.plugin.zsh"