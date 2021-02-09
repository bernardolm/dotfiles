#!/bin/bash

source $BASE_PATH/msg.sh

msg_init '3rd party packages'

[ -f ~/tmp/apt_3rd_party_packages ] || touch -d "2 years ago" ~/tmp/apt_3rd_party_packages

if test `find ~/tmp/apt_3rd_party_packages -mmin +180`; then
    sudo apt-get install --yes --no-install-recommends \
        balena-etcher-electron \
        gh \
        google-chrome-stable \
        google-cloud-sdk \
        kubectl \
        libreoffice-calc \
        nmap \
        python-gtk2 \
        stacer \
        sublime-text \
        wine-staging \
        wine-staging-amd64 \
        winehq-staging

    if [[ `hostname` != hunb* ]]; then
        sudo apt-get install --yes --no-install-recommends \
            ungoogled-chromium
    fi

    sudo apt-get install -f --yes

    touch ~/tmp/apt_3rd_party_packages
else
    echo "3rd party packages updated"
fi

msg_end '3rd party packages'
