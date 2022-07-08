#!/bin/bash

source ../setup/env.sh
source ../setup/functions_loader.sh

msg_start 'post install'

sudo apt-get --purge --yes autoremove
[ `command -v zsh` ] && chsh -s $(which zsh)
fc-cache -f -v > /dev/null
gnome-extensions disable ubuntu-dock@ubuntu.com
gsettings set org.cinnamon.desktop.wm.preferences num-workspaces 1

# echo "net.ipv6.conf.all.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
# echo "net.ipv6.conf.default.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
# echo "net.ipv6.conf.lo.disable_ipv6=1" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=25" | sudo tee -a /etc/sysctl.conf
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf
sudo ulimit -n 131072 || true
sudo ulimit -u 8192 || true

gconftool-2 --shutdown
gconftool-2 --spawn

msg_end 'post install'
