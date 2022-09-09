# Loading setup scripts
declare -a setup_script_paths=(
    "$DOTFILES/setup"
    "$DOTFILES/aliases"
    "$SYNC_PATH/setup"
)

declare -a custom_script_paths=(
    "$DOTFILES/bash"
    "$DOTFILES/shell"
    "$DOTFILES/zsh"
    "$SYNC_PATH/bash"
    "$SYNC_PATH/shell"
    # "$SYNC_PATH/zsh"
)

load_script_path "${setup_script_paths[@]}"
load_script_path "${custom_script_paths[@]}"

eval "$(thefuck --alias)"

# eval $(op signin my)
# op signin --list
