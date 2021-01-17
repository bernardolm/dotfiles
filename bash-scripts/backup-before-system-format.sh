#!/usr/bin/zsh
source ~/.zshrc

# TODO:
# [x] backup apt packages list with a timestamp
# [x] backup crontab list
# [ ] backup resolve.conf.d files
# [x] backup snap packages list with a timestamp


backup_gnome
backup_guake

crontab -l > $SYNC_PATH/crontab
dpkg --get-selections > $SYNC_PATH/Package.list
snap list > $SYNC_PATH/snap.list

backup_my_sym_links
