function sanitize_gnome_packages() {
    sudo apt purge --yes aisleriot deja-dup gnome-mahjongg gnome-mines gnome-sudoku ^gnome-todo ^remmina ^rhythmbox \
        ^thunderbird ^totem ^transmission libreoffice-draw libreoffice-impress libreoffice-writer gnome-2048 glade
}
