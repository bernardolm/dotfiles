#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'setting ssh'

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C `git config user.email`
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    [ `command -v xclip` ] || sudo apt-get install xclip
    xclip -selection clipboard < ~/.ssh/id_ed25519.pub
    echo "The generated SSH key is on your clipboard. Now, you need to follow the steps in https://docs.github.com/pt/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account to link your SSH key to github."
    read -p "Press enter to continue..." y
fi

msg_end 'setting ssh'
