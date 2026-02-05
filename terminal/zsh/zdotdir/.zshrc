echo "\$ZDOTDIR/.zshrc"

echo zshrc begin

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# Run others inits
for file in "$DOTFILES/terminal/zsh/zshrc.d/"*; do
  if [ -f "$file" ]; then
		echo -n "$(basename "$file" .sh), "
		. "$file"
	fi
done
tput cub 2 && echo -n " \n"

echo zshrc end
