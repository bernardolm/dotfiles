# Interactive shell setup.

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]] && command -v curl >/dev/null 2>&1; then
	curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
		https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ -r ${ZIM_HOME}/zimfw.zsh ]]; then
	if [[ ! -e ${ZIM_HOME}/init.zsh ]] || [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
		source ${ZIM_HOME}/zimfw.zsh init
	fi
	if [[ -r ${ZIM_HOME}/init.zsh ]]; then
		source ${ZIM_HOME}/init.zsh
	fi
fi

for file in "$DOTFILES/terminal/zsh/zshrc.d/"*.zsh; do
	[ -r "$file" ] || continue
	. "$file"
done
