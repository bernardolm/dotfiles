#!/bin/bash

BASE_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

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

# STEPS:
# 1. ask to remove /etc/apt/sources.list.d (backup before) and link with related back folder
# 2. run get keys (needs curl)
# 3. apt update and apt upgrade
# 4. install packages and apps
# 5. restore gnome
# 6. restore guake

## Upgrade ubuntu
msg_init 'upgrading ubuntu'
sudo apt upgrade --yes

## Run install scripts
$BASE_PATH/install_base_packages.sh
$BASE_PATH/install_3rd_party_packages.sh
$BASE_PATH/install_3rd_party_apps.sh
$BASE_PATH/install_snap_packages.sh

# post install
msg_init 'running post install commands'
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
