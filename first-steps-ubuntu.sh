#!/bin/bash
set -e

export BASE_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source $BASE_PATH/msg.sh

msg_welcome() {
    echo ''
    echo ''
    echo ' __    ____  ____  _ ____     ___   __  '
    echo '(  )  (  __)(_  _)(// ___)   / __) /  \ '
    echo '/ (_/\ ) _)   )(    \___ \  ( (_ \(  O )'
    echo '\____/(____) (__)   (____/   \___/ \__/ '
    echo ' ____  __  ____  ____  ____ '
    echo '(  __)(  )(  _ \/ ___)(_  _)'
    echo ' ) _)  )(  )   /\___ \  )(  '
    echo '(__)  (__)(__\_)(____/ (__) '
    echo ' ____  ____  ____  ____  ____ '
    echo '/ ___)(_  _)(  __)(  _ \/ ___)'
    echo '\___ \  )(   ) _)  ) __/\___ \'
    echo '(____/ (__) (____)(__)  (____/'
    echo ' _  _  ____  _  _  __ _  ____  _  _ '
    echo '/ )( \(  _ \/ )( \(  ( \(_  _)/ )( \'
    echo ') \/ ( ) _ () \/ (/    /  )(  ) \/ ('
    echo '\____/(____/\____/\_)__) (__) \____/'
    echo ''
    echo ''
    echo ''
}

msg_welcome

## Upgrade ubuntu
msg_init 'upgrading ubuntu'
sudo apt upgrade --yes
msg_end 'upgrading ubuntu'

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
