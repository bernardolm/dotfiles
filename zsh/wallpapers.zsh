function wallpaperz_reindex() {
    sh $SYNC_PATH/Pictures/Wallpapers/ubuntu-wallpaper-generator $SYNC_PATH/Pictures/Wallpapers
    if ! [ -s "/usr/share/gnome-background-properties/ubuntu-wallpapers.xml" ]; then \
        echo "ubuntu-wallpapers.xml not exist, creating..."; \
        sudo touch /usr/share/gnome-background-properties/ubuntu-wallpapers.xml; \
    fi
    sudo cp /usr/share/gnome-background-properties/ubuntu-wallpapers.xml /usr/share/gnome-background-properties/ubuntu-wallpapers.xml.backup
    sudo mv ubuntu-wallpapers.xml /usr/share/gnome-background-properties/ubuntu-wallpapers.xml
}
