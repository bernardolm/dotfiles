#!/bin/bash

source msg.sh

msg_init '3rd party packages install'

sudo apt install --yes --no-install-recommends \
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

msg_end 'base packages'
