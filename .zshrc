# ---------------------------------- zshrc from official repository -----------
# export ZSH="$HOME/.oh-my-zsh"
# export ZSH="$ZINIT_ROOT/plugins/ohmyzsh---ohmyzsh"
# export ZSH="/home/bernardo/.local/share/zinit/plugins/ohmyzsh---ohmyzsh"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="spaceship"
# plugins=(git)
# source $ZSH/oh-my-zsh.sh

# ---------------------------------- start -------------------------------------
# DEBUG_SHELL=true

[ $DEBUG ] && set -x

export DEBUG_SHELL=$(test -z "$DEBUG_SHELL" && echo "false" || echo $DEBUG_SHELL)
$DEBUG_SHELL && echo "\033[1;31m📢 📢 📢 running in DEBUG mode\033[0m\n"

# ---------------------------------- setup ------------------------------------
source $HOME/env.sh &&
source $DOTFILES/shell/session.sh &&
start_zsh_session
log_zsh_session $HOME/env.sh
log_zsh_session $DOTFILES/shell/session.sh

source_and_log_session $DOTFILES/shell/function.sh

export setup_script_order=(
    zsh.sh
    zinit.sh
    ohmyzsh.sh
    spaceship.sh
    todo_txt.sh
    conky.sh
    misc.sh
)

for file in $setup_script_order; do
    local full_path=$DOTFILES/setup/$file
    load_script_path $full_path
done

finish_zsh_session

# ---------------------------------- something else? --------------------------
[ -f /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash ] \
    && source_and_log_session /usr/local/lib/node_modules/hudctl/completion/hudctl-completion.bash

[ `command -v disable_accelerometter` ] && disable_accelerometter

eval `dircolors $HOME/.dir_colors`
