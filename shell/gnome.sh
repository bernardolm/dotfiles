function backup_gnome() {
    dconf dump /org/gnome/ > "$SYNC_PATH/backup_of_my_gnome_settings"
}

function restore_gnome() {
    dconf reset -f /org/gnome/
    if [[ `hostname` == hunb* ]]; then
        dconf load /org/gnome/ <$SYNC_PATH/backup_of_my_gnome_settings
    else
        /bin/cat "$SYNC_PATH/backup_of_my_gnome_settings" | grep -v "text-scaling-factor" >~/tmp/backup_of_my_gnome_settings
        dconf load /org/gnome/ <~/tmp/backup_of_my_gnome_settings
    fi
}
