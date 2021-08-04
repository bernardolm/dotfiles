function backup_guake() {
    dconf dump /apps/guake/ > "$SYNC_PATH/backup_of_my_guake_settings"
}

function restore_guake() {
    dconf reset -f /apps/guake/
    dconf load /apps/guake/ < "$SYNC_PATH/backup_of_my_guake_settings"
}
