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

## Upgrade ubuntu
msg_init 'ubuntu upgrade'
sudo apt upgrade --yes
msg_end 'ubuntu upgrade'

# Creating temp folder
[ ! -f ~/tmp ] && mkdir -p ~/tmp

## Run install scripts
$BASE_PATH/install_remote_folder.sh
$BASE_PATH/restore-my-sym-links.sh
$BASE_PATH/setting-apt.sh
$BASE_PATH/install_base_packages.sh
$BASE_PATH/install_3rd_party_packages.sh
$BASE_PATH/install_3rd_party_apps.sh
$BASE_PATH/install_snap_packages.sh

# post install
msg_init 'running post install commands'
sudo apt --purge autoremove
chsh -s $(which zsh)
fc-cache -f -v > /dev/null
gnome-extensions disable ubuntu-dock@ubuntu.com
# pip3 install -U --user pygments
echo -e "vm.swappiness=0" | sudo tee -a /etc/sysctl.conf
echo -e "#\x21/bin/sh\\nfstrim -v /" | sudo tee /etc/cron.daily/trim
sudo chmod +x /etc/cron.daily/trim
# add noatime,nodiratime flag to /etc/fstab
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

## Reload gconfs
gconftool-2 --shutdown
gconftool-2 --spawn

echo -e '\n\n🏁 thats all folks... bye!'
