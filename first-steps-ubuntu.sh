#!/bin/bash

msg_welcome() {
    echo '                                                                                                  '
    echo '                                                                                                  '
    echo ' __    ____  ____  _ ____     ___   __                                                            '
    echo '(  )  (  __)(_  _)(// ___)   / __) /  \                                                           '
    echo '/ (_/\ ) _)   )(    \___ \  ( (_ \(  O )                                                          '
    echo '\____/(____) (__)   (____/   \___/ \__/                                                           '
    echo ' ____  __  ____  ____  ____    ____  ____  ____  ____  ____    _  _  ____  _  _  __ _  ____  _  _ '
    echo '(  __)(  )(  _ \/ ___)(_  _)  / ___)(_  _)(  __)(  _ \/ ___)  / )( \(  _ \/ )( \(  ( \(_  _)/ )( \'
    echo ' ) _)  )(  )   /\___ \  )(    \___ \  )(   ) _)  ) __/\___ \  ) \/ ( ) _ () \/ (/    /  )(  ) \/ ('
    echo '(__)  (__)(__\_)(____/ (__)   (____/ (__) (____)(__)  (____/  \____/(____/\____/\_)__) (__) \____/'
    echo '                                                                                                  '
    echo '                                                                                                  '
    echo '                                                                                                  '
}

msg_welcome

# TODO:
# install get-keys and run after update sources
# run apt install -f after all


source install_getkeys.sh
source install_base_packages.sh
source install_snap_packages.sh
source install_3rd_party_packages.sh
source refresh-all-git.sh

# post install

sudo apt install -f

## VS Code
xdg-mime default code.desktop text/plain
sudo update-alternatives --set editor /usr/bin/code
## Upgrade machine
sudo apt upgrade --yes
## Update fonts cahe
fc-cache -f -v
## Reload gconfs
gconftool-2 --shutdown
gconftool-2 --spawn


echo -e '\n\nthats all folks\nbye'
