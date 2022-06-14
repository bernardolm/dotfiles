#!/bin/zsh

source ./shell/init/env.sh
source ./shell/init/functions_loader.sh

msg_start '3rd party packages'

# NOTE: Restoring by last installed backup

[ -f ~/tmp/apt_3rd_party_packages ] || touch -d "2 years ago" ~/tmp/apt_3rd_party_packages

if test `find ~/tmp/apt_3rd_party_packages -mmin +180`; then
    sudo apt-get install --yes --no-install-recommends \
        gh \
        google-chrome-stable \
        libreoffice-calc \
        nmap \
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
