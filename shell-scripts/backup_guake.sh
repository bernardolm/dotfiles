function backup_guake () {
    dconf dump /apps/guake/ > "$SYNC_PATH/backup_of_my_guake_settings"
}
