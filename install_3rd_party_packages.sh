#!/bin/zsh

source msg.sh

msg_init '3rd party packages install'

# [x] balena etcher  https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
# [x] bleachbit      https://www.bleachbit.org/download/linux
# [x] docker         https://docs.docker.com/engine/install/ubuntu/
# [x] dropbox        https://www.dropbox.com/install-linux
# [x] fzf            https://github.com/junegunn/fzf
# [x] gcloud         https://cloud.google.com/sdk/docs/downloads-apt-get
# [x] golang         https://golang.org/doc/install
# [x] guake          https://github.com/Guake/guake
# [x] stacer         https://github.com/oguzhaninan/Stacer
# [x] stremio        https://www.stremio.com/downloads#linux
# [x] tixati         https://www.tixati.com/download/linux.html
# [x] todo.sh        https://github.com/todotxt/todo.txt-cli
# [x] winehq-staging https://wiki.winehq.org/Ubuntu - https://plus.diolinux.com.br/t/sketchup-no-linux/10347/6 - To use Sketchup 2017
# [x] zinit          https://github.com/zdharma/zinit

# Checkers

if [[ "$(which zsh)" == "" ]]; then
   echo -e "\n🚨 this script needs to run with zsh installed, exiting..."
   exit 1
fi

source ~/.zshrc

if [[ "$SYNC_PATH" == "" ]]; then
   echo -e "\n🚨 this script needs to run over $USER zsh profile, exiting..."
   exit 1
fi

# Begin

if [[ "$(command -v /opt/balenaEtcher/balena-etcher-electron)" == "" ]]; then
   echo -e "\n💾 installing electron..."
   sudo apt-get install --yes balena-etcher-electron
fi

if [[ "$(command -v bleachbit)" == "" ]]; then
   echo -e "\n💾 installing bleachbit..."
   curl https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1904.deb -o /tmp/bleachbit.deb && sudo dpkg -i /tmp/bleachbit.deb
fi

if [[ "$(command -v docker)" == "" ]]; then
   echo -e "\n💾 installing docker..."
   sudo apt install --yes docker-ce docker-ce-cli containerd.io
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
fi

if [[ "$(command -v dropbox)" == "" ]]; then
   echo -e "\n💾 installing dropbox..."
   nautilus --quit
   curl https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb -o /tmp/dropbox.deb && sudo dpkg -i /tmp/dropbox.deb
   sudo mkdir -p /var/log/dropbox_schedule
   sudo chown -R $USER:$USER /var/log/dropbox_schedule
fi

if [[ "$(command -v fzf)" == "" ]]; then
   echo -e "\n💾 installing fzf..."
   if [ ! -d "~/.fzf" ]; then
      echo "cloning fzf..."
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   fi
   ~/.fzf/install
fi

if [[ "$(command -v gcloud)" == "" ]]; then
   echo -e "\n💾 installing gcloud..."
   sudo apt install --yes google-cloud-sdk
   # gcloud init
fi

if [[ "$(command -v go)" == "" ]]; then
   echo -e "\n💾 installing go..."
   wget --quiet https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O /tmp/go.tar.gz
   sudo /bin/rm -rf $USER/golang/pkg
   sudo tar -C /usr/local -xzf /tmp/go.tar.gz
fi

if [[ "$(command -v guake)" == "" ]]; then
   echo -e "\n💾 installing guake..."
   if [ ! -d "$WORKSPACE_USER/guake" ]; then
      echo "cloning guake..."
      git clone --depth 1 https://github.com/Guake/guake.git $WORKSPACE_USER/guake
   fi
   cd $WORKSPACE_USER/guake
   ./scripts/bootstrap-dev-debian.sh run make
   make
   sudo make install
   cd -
fi

if [[ "$(command -v stacer)" == "" ]]; then
   echo -e "\n💾 installing stacer linux system optimizer & monitor..."
   sudo apt-get install --yes stacer
fi

if [[ "$(command -v stremio)" == "" ]]; then
   echo -e "\n💾 installing stremio..."
   curl https://dl.strem.io/shell-linux/v4.4.116/stremio_4.4.116-1_amd64.deb -o /tmp/stremio.deb && sudo dpkg -i /tmp/stremio.deb
   sudo apt install --yes -f
fi

if [[ "$(command -v tixati)" == "" ]]; then
   echo -e "\n💾 installing tixati..."
   curl https://download2.tixati.com/download/tixati_2.75-1_amd64.deb -o /tmp/tixati.deb && sudo dpkg -i /tmp/tixati.deb
fi

if [[ "$(command -v todo.sh)" == "" ]]; then
   echo -e "\n💾 installing todo.sh..."
   mkdir tmp
   curl -s -L https://github.com/todotxt/todo.txt-cli/releases/download/v2.12.0/todo.txt_cli-2.12.0.zip -o tmp/todo.zip
   unzip tmp/todo.zip -d tmp/todo
   yes | mv tmp/todo/todo.txt_cli-2.12.0.dirty/todo.sh $SYNC_PATH/bin
   yes | mv tmp/todo/todo.txt_cli-2.12.0.dirty/todo_completion $SYNC_PATH/todo_txt
   /bin/rm -rf tmp/todo tmp/todo.zip
fi

if [[ "$(command -v wine)" == "" ]]; then
   echo -e "\n💾 installing wine..."
   sudo dpkg --add-architecture i386
   # wget -nc https://dl.winehq.org/wine-builds/winehq.key
   # sudo apt-key add winehq.key
   sudo apt install --yes libvulkan1 libvulkan-dev vulkan-utils winehq-staging winetricks
fi

if [[ "$(command -v zinit)" == "off" ]]; then
   echo -e "\n💾 installing zinit..."
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

sudo apt install -f

msg_end '3rd party packages'
