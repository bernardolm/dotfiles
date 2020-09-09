#!/bin/bash

source msg.sh

msg_init '3rd party packages'

# [x] ag (ack)       https://github.com/ggreer/the_silver_searcher
# [x] balena etcher  https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
# [x] bleachbit      https://www.bleachbit.org/download/linux
# [x] docker         https://docs.docker.com/engine/install/ubuntu/
# [x] dropbox        https://www.dropbox.com/install-linux
# [x] fzf            https://github.com/junegunn/fzf
# [x] gcloud         https://cloud.google.com/sdk/docs/downloads-apt-get
# [x] guake          https://github.com/Guake/guake
# [x] stremio        https://www.stremio.com/downloads#linux
# [x] sublime text   https://www.sublimetext.com/docs/3/linux_repositories.html
# [x] tixati         https://www.tixati.com/download/linux.html
# [x] todo.sh        https://github.com/todotxt/todo.txt-cli
# [x] vscode         https://code.visualstudio.com/docs/setup/linux
# [x] zinit          https://github.com/zdharma/zinit

if [[ "$(command -v /opt/balenaEtcher/balena-etcher-electron)" == "" ]]; then
   echo "installing electron..."
   sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 379CE192D401AB61
   echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
   sudo apt-get update
   sudo apt-get install --yes balena-etcher-electron
fi

if [[ "$(command -v docker)" == "" ]]; then
   echo "installing docker..."
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
   sudo apt install --yes docker-ce docker-ce-cli containerd.io
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
fi

if [[ "$(command -v gcloud)" == "" ]]; then
   echo "installing gcloud..."
   curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
   echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
   sudo apt update
   sudo apt install --yes google-cloud-sdk
   gcloud init
fi

if [[ "$(command -v subl)" == "" ]]; then
   echo "installing subl..."
   wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
   echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
   sudo apt update
   sudo apt install --yes sublime-text
fi

if [[ "$(command -v code)" == "" ]]; then
   echo "installing vscode..."
   wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
   sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
   sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
   sudo apt update
   sudo apt install --yes code
   sudo apt install --yes -f
fi

if [[ "$(command -v todo.sh)" == "" ]]; then
   echo "installing todo.sh..."
   curl -s -L https://github.com/todotxt/todo.txt-cli/releases/download/v2.11.0/todo.txt_cli-2.11.0.zip -o /tmp/todo.zip
   unzip /tmp/todo.zip -d /tmp/todo
   mv /tmp/todo/todo.txt_cli-2.11.0/todo.sh $SYNC_PATH/bin
   mv /tmp/todo/todo.txt_cli-2.11.0/todo_completion $SYNC_PATH/todo_txt
   /bin/rm -rf /tmp/todo /tmp/todo.zip
fi

if [[ "$(command -v fzf)" == "" ]]; then
   echo "installing fzf..."
   if [ ! -d "~/.fzf" ]; then
      echo "cloning fzf..."
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   fi
   ~/.fzf/install
fi

if [[ "$(command -v guake)" == "" ]]; then
   echo "installing guake..."
   if [ ! -d "$WORKSPACE_USER/guake" ]; then
      echo "cloning guake..."
      git clone --depth 1 https://github.com/Guake/guake.git $WORKSPACE_USER/guake
   fi
   ./scripts/bootstrap-dev-debian.sh run make
   make
   sudo make install
fi

if [[ "$(command -v bleachbit)" == "" ]]; then
   echo "installing bleachbit..."
   curl https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1904.deb -o /tmp/bleachbit.deb && sudo dpkg -i /tmp/bleachbit.deb
fi

if [[ "$(command -v stremio)" == "" ]]; then
   echo "installing stremio..."
   curl https://dl.strem.io/shell-linux/v4.4.116/stremio_4.4.116-1_amd64.deb -o /tmp/stremio.deb && sudo dpkg -i /tmp/stremio.deb
   sudo apt install --yes -f
fi

if [[ "$(command -v tixati)" == "" ]]; then
   echo "installing tixati..."
   curl https://download2.tixati.com/download/tixati_2.75-1_amd64.deb -o /tmp/tixati.deb && sudo dpkg -i /tmp/tixati.deb
fi

if [[ "$(command -v zinit)" == "off" ]]; then
   echo "installing zinit..."
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

if [[ "$(command -v dropbox)" == "" ]]; then
   echo "installing dropbox..."
   nautilus --quit
   curl https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb -o /tmp/dropbox.deb && sudo dpkg -i /tmp/dropbox.deb
fi

msg_end '3rd party packages'
