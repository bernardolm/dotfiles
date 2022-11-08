function antigen_purge() {
    rm -rf "$SYNC_PATH/bin/antigen.zsh"
    rm -rf ~/.antigen
}
