#!/bin/bash

source msg.sh

msg_init '3rd party packages'

# [ ] balena etcher
# [ ] BleachBit - https://www.bleachbit.org/download/linux
# [ ] BricsCAD Shape - https://www.bricsys.com/protected/download.do?p=shape
# [ ] docker-ce
# [ ] gcloud
# [ ] guake - https://github.com/Guake/guake
# [ ] Pinta - Ubuntu Software Center
# [ ] stremio - https://www.stremio.com/downloads#linux
# [ ] Sublime text
# [ ] Tixati - https://www.tixati.com/download/linux.html
# [ ] VS Code
# [x] todo.txt
# [ ] zinit - sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
# [ ] fzf - git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
# [ ] ag (ack) - https://github.com/ggreer/the_silver_searcher


echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 379CE192D401AB61
sudo apt-get update
sudo apt-get install balena-etcher-electron


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker


echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk


curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install sublime-text


curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code


curl -s -L https://github.com/todotxt/todo.txt-cli/releases/download/v2.11.0/todo.txt_cli-2.11.0.zip -o todo.zip
unzip todo.zip -d todo
mv todo/todo.txt_cli-2.11.0/todo.sh $SYNC_PATH/bin
mv todo/todo.txt_cli-2.11.0/todo_completion $SYNC_PATH/todo_txt
/bin/rm -rf todo todo.zip


msg_end '3rd party packages'
