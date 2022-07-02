# ---------------------------------- zshrc from official repository -----------
# export ZSH="$HOME/.oh-my-zsh"
# export ZSH="$ZINIT_ROOT/plugins/ohmyzsh---ohmyzsh"
# export ZSH="/home/bernardo/.local/share/zinit/plugins/ohmyzsh---ohmyzsh"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="spaceship"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh

# ---------------------------------- inits ------------------------------------
# DEBUG_SHELL=true

[ $DEBUG ] && set -x

export DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)
$DEBUG_SHELL && echo "\033[1;31m📢 📢 📢 running in DEBUG mode\033[0m\n"

# ---------------------------------- inits ------------------------------------
source $HOME/env.sh
source $DOTFILES/shell/function.sh

export INIT_SCRIPTS=(zsh.sh zinit.sh ohmyzsh.sh spaceship.sh todo_txt.sh conky.sh init.sh)

for file in $INIT_SCRIPTS; do
    local full_path=$DOTFILES/shell/init/$file
    load_script_path $full_path
done

# ---------------------------------- something else? --------------------------
[ -f /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash ] \
    && source /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash

[ `command -v disable_accelerometter` ] && disable_accelerometter

eval `dircolors $HOME/.dir_colors`
