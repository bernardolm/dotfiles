#!/bin/bash

source msg.sh

msg_init 'base packages'

sudo add-apt-repository ppa:nilarimogard/webupd8 && \
sudo apt update && \
sudo apt install launchpad-getkeys && \
sudo launchpad-getkeys

msg_end 'base packages'
