#!/usr/bin/zsh
source ~/.zshrc

# TODO:
# [ ] backup resolve.conf.d files

backup_apt_packages
backup_gnome
backup_guake
backup_my_sym_links
backup_python_packages
backup_repositories_config
backup_snap_packages
backup-crontab

source $WORKSPACE_USER/first-steps-ubuntu/shell-scripts/git_workspaces.sh

backup_git_workspaces $WORKSPACE_USER user
backup_git_workspaces $WORKSPACE_ORG org
