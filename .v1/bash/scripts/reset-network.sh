#!/usr/bin/env /bin/zsh

sudo dhclient -r || true
sudo iptables -F || true
sudo iptables -F INPUT || true
sudo iptables -F OUTPUT || true
sudo iptables -P INPUT ACCEPT || true
sudo iptables -P OUTPUT ACCEPT || true
sudo ip addr flush eth0 || true
sudo netplan apply || true
sudo service ssh restart || true
ping -c 5 www.docker.com | grep loss
ping -c 5 www.ubuntu.com.br | grep loss
ping -c 5 www.google.com | grep loss
