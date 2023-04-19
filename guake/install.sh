#!/usr/bin/env zsh

echo "you need to install guake by apt"
exit 0

[ ! -d "$WORKSPACE_USER/guake" ] && git clone https://github.com/Guake/guake.git $WORKSPACE_USER/guake
cd $WORKSPACE_USER/guake
git pull origin master
./scripts/bootstrap-dev-debian.sh run make
make
sudo make install
cd -
dbus-send --type=method_call --dest=org.guake3.RemoteControl /org/guake3/RemoteControl org.guake3.RemoteControl.show_hide
