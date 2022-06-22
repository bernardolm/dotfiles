function load_aliases() {
    local paths=("$SYNC_PATH/aliases" "$DOTFILES/aliases")
    
    for f in $paths; do
        if [ -f $f ]; then
            $DEBUG_SHELL && echo "loading path aliases in $f"
            source $f
        fi
    done
}
