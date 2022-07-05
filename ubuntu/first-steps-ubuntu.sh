#!/bin/zsh
set -e
set -a

source ./shell/init/env.sh
source ./shell/init/functions_loader.sh

msg_welcome() {
    echo ""
    echo " ___ _         _          _                  _            _           _       "
    echo "|  _|_|___ ___| |_    ___| |_ ___ ___ ___   |_|___    _ _| |_ _ _ ___| |_ _ _ "
    echo "|  _| |  _|_ -|  _|  |_ -|  _| -_| . |_ -|  | |   |  | | | . | | |   |  _| | |"
    echo "|_| |_|_| |___|_|    |___|_| |___|  _|___|  |_|_|_|  |___|___|___|_|_|_| |___|"
    echo "                                 |_|                                          "
    echo ""
}

msg_welcome

# Creating temp folder
[ ! -f ~/tmp ] && mkdir -p ~/tmp

## Run install scripts
$BASE_PATH/install-remote-folder.sh
source $BASE_PATH/shell/symbolic_links.sh
restore_symbolic_links
$BASE_PATH/setting-apt.sh
# $BASE_PATH/install-base-packages.sh
# $BASE_PATH/install-3rd-party-packages.sh
$BASE_PATH/setting-ssh.sh
# $BASE_PATH/install-3rd-party-apps.sh
# $BASE_PATH/install-snap-packages.sh
$BASE_PATH/post-install.sh

echo -e "\n\n🏁 thats all folks... bye!"