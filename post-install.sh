#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'post install'

sudo apt --purge --yes autoremove
chsh -s $(which zsh)
fc-cache -f -v > /dev/null
gnome-extensions disable ubuntu-dock@ubuntu.com

# echo "net.ipv6.conf.all.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
# echo "net.ipv6.conf.default.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
# echo "net.ipv6.conf.lo.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=25" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

gconftool-2 --shutdown
gconftool-2 --spawn

msg_end 'post install'
