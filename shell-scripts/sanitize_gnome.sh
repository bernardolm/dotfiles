function sanitize_gnome() {
    NOW=$(date +"%Y-%m-%d-%H-%M-%S")
    mkdir -p ~/.old-gnome-config/${NOW}
    sudo mv ~/.gnome* ~/.old-gnome-config/${NOW}
    sudo mv ~/.gconf* ~/.old-gnome-config/${NOW}
    sudo mv ~/.metacity ~/.old-gnome-config/${NOW}
    sudo mv ~/.cache ~/.old-gnome-config/${NOW}
    sudo mv ~/.dbus ~/.old-gnome-config/${NOW}
    sudo mv ~/.dmrc ~/.old-gnome-config/${NOW}
    sudo mv ~/.mission-control ~/.old-gnome-config/${NOW}
    sudo mv ~/.thumbnails ~/.old-gnome-config/${NOW}
    sudo mv ~/.config/dconf/* ~/.old-gnome-config/${NOW}
    dconf reset -f /org/gnome/
}
