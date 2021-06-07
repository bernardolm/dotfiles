#!/usr/bin/zsh
source ~/.zshrc

# TODO:
# [x] backup apt packages list with a timestamp
# [x] backup crontab list
# [ ] backup resolve.conf.d files
# [x] backup snap packages list with a timestamp
# [x] workspace repos

backup_gnome
backup_guake

backup-crontab

dpkg --get-selections >$SYNC_PATH/Package_$(hostname).list
snap list >$SYNC_PATH/snap_$(hostname).list

backup_my_sym_links

source $WORKSPACE_USER/first-steps-ubuntu/shell-scripts/git_workspaces.sh

backup_git_workspaces $WORKSPACE_USER user
backup_git_workspaces $WORKSPACE_ORG org
