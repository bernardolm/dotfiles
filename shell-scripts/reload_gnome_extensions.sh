reload_gnome_extensions () {
    active_extensions=$(gsettings get org.gnome.shell enabled-extensions)
    gsettings set org.gnome.shell enabled-extensions "$active_extensions"
}
