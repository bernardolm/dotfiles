#!/bin/bash

source $BASE_PATH/msg.sh

msg_init '3rd party packages'

sudo apt update

sudo apt install --yes --no-install-recommends \
    gh \
    google-chrome-stable \
    google-cloud-sdk \
    kubectl \
    libreoffice-calc \
    nmap \
    python-gtk2 \
    stacer \
    sublime-text \
    ungoogled-chromium \
    wine-staging \
    wine-staging-amd64 \
    winehq-staging

sudo apt install -f

msg_end '3rd party packages'
