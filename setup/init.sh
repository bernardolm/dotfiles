# Loading init scripts
declare -a init_script_paths=(
    "$DOTFILES/shell/init"
    "$DOTFILES/aliases"
    "$SYNC_PATH/shell/init"
    "$SYNC_PATH/aliases"
)

declare -a custom_script_paths=(
    "$DOTFILES/bash"
    "$DOTFILES/shell"
    "$DOTFILES/zsh"
    "$SYNC_PATH/bash"
    "$SYNC_PATH/shell"
    # "$SYNC_PATH/zsh"
)

echo ""
load_script_path "${init_script_paths[@]}"
load_script_path "${custom_script_paths[@]}"
