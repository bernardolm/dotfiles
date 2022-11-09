function guake_backup() {
    dconf dump /apps/guake/ > "$SYNC_PATH/backup_of_my_guake_settings"
}

function guake_restore() {
    dconf reset -f /apps/guake/
    dconf load /apps/guake/ < "$SYNC_PATH/backup_of_my_guake_settings"
}

function guake_update() {
    git --git-dir $WORKSPACE_USER/guake/.git checkout .
    git --git-dir $WORKSPACE_USER/guake/.git checkout master
    sudo make --directory $WORKSPACE_USER/guake uninstall
    make --directory $WORKSPACE_USER/guake
    sudo make --directory $WORKSPACE_USER/guake install
    make --directory $WORKSPACE_USER/guake reinstall
}
