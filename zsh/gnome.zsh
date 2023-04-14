function gnome_backup() {
    local now=$(date +"%Y%m%d%H%M%S")
    dconf dump /org/gnome/ > "$SYNC_DOTFILES/gnome/$now.txt"
}

function gnome_reset() {
    dconf reset -f /org/gnome/
}

function gnome_restore() {
    local file=$(last_backup_version gnome txt)
    gnome_reset
    dconf load /org/gnome/ <"$file"
}

function gnome_sanitize() {
    NOW=$(date +"%Y%m%d%H%M%S")
    mkdir -p ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.gnome* ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.gconf* ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.metacity ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.cache ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.dbus ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.dmrc ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.mission-control ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.thumbnails ~/tmp/old-gnome-config/${NOW}
    sudo mv ~/.config/dconf/* ~/tmp/old-gnome-config/${NOW}
    dconf reset -f /org/gnome/
}

function gnome_shell_extensions_reload() {
    active_extensions=$(gsettings get org.gnome.shell enabled-extensions)
    gsettings set org.gnome.shell enabled-extensions "$active_extensions"
}

function gnome_shell_extensions_purge_dock() {
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
    gsettings set org.gnome.shell enable-hot-corners false
    sudo apt remove gnome-shell-extension-ubuntu-dock
    gnome-extensions disable ubuntu-dock@ubuntu.com
}
