#!/usr/bin/zsh
source ~/.zshrc

backup_gnome
backup_guake

crontab -l > $SYNC_PATH/crontab
dpkg --get-selections > $SYNC_PATH/Package.list
snap list > $SYNC_PATH/snap.list

backup_my_sym_links
