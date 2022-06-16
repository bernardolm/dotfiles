function load_aliases() {
    [ -f $SYNC_PATH/aliases ] \
        && (($DEBUG_SHELL && echo "loading sync path aliases in $SYNC_PATH/aliases") || true) \
        && source $SYNC_PATH/aliases
    [ -f $DOTFILES/aliases ] \
        && (($DEBUG_SHELL && echo "loading git path aliases in $DOTFILES/aliases") || true) \
        && source $DOTFILES/aliases
}
