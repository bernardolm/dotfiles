#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'post install'

sudo apt --purge --yes autoremove
chsh -s $(which zsh)
fc-cache -f -v > /dev/null
gnome-extensions disable ubuntu-dock@ubuntu.com

# sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
# sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
# sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

gconftool-2 --shutdown
gconftool-2 --spawn

msg_end 'post install'
