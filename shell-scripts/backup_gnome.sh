backup_gnome () {
    dconf dump /org/gnome/ > "$SYNC_PATH/backup_of_my_gnome_settings"
}
