# Login shell initialisation.

pyenv_init_file="$HOME/dotfiles/cli/zsh/zshrc.d/00_pyenv.zsh"
if [ -r "$pyenv_init_file" ]; then
	. "$pyenv_init_file"
fi
