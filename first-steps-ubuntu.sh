#!/bin/bash
set -e

export BASE_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source $BASE_PATH/msg.sh

msg_welcome() {
    echo ''
    echo ' ___ _         _          _                  _            _           _       '
    echo '|  _|_|___ ___| |_    ___| |_ ___ ___ ___   |_|___    _ _| |_ _ _ ___| |_ _ _ '
    echo '|  _| |  _|_ -|  _|  |_ -|  _| -_| . |_ -|  | |   |  | | | . | | |   |  _| | |'
    echo '|_| |_|_| |___|_|    |___|_| |___|  _|___|  |_|_|_|  |___|___|___|_|_|_| |___|'
    echo '                                 |_|                                          '
    echo ''
}

msg_welcome

# Creating temp folder
[ ! -f ~/tmp ] && mkdir -p ~/tmp

## Run install scripts
$BASE_PATH/install-remote-folder.sh
$BASE_PATH/restore-my-sym-links.sh
$BASE_PATH/setting-apt.sh
$BASE_PATH/install-base-packages.sh
$BASE_PATH/install-3rd-party-packages.sh
$BASE_PATH/setting-ssh.sh
$BASE_PATH/install-3rd-party-apps.sh
$BASE_PATH/install-snap-packages.sh
$BASE_PATH/post-install.sh

echo -e '\n\n🏁 thats all folks... bye!'
