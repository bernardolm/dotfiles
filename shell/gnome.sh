function backup_gnome() {
    local now=$(date +"%Y%m%d%H%M%S")
    dconf dump /org/gnome/ > "$SYNC_PATH/gnome/$now.txt"
}

function reset_gnome() {
    dconf reset -f /org/gnome/
}

function restore_gnome() {
    local file=$(last_backup_version gnome txt)
    reset_gnome
    dconf load /org/gnome/ <$file
}
