function sanitize_gnome_packages() {
    sudo apt purge --yes
        ^gnome-todo \
        ^remmina \
        ^rhythmbox \
        ^thunderbird \
        ^totem \
        ^transmission \
        aisleriot \
        deja-dup \
        glade \
        xserver-xorg-input-wacom \
        gnome-2048 \
        gnome-mahjongg \
        gnome-mines \
        gnome-sudoku \
        libreoffice-draw \
        libreoffice-impress \
        libreoffice-writer \
        $$ true
}
