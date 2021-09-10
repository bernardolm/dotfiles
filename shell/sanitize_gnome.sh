function sanitize_gnome() {
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
