function backup_all() {
    # TODO:
    # [ ] backup resolve.conf.d files

    backup_apt_packages
    backup_crontab
    backup_git_workspaces $WORKSPACE_ORG org
    backup_git_workspaces $WORKSPACE_USER user
    backup_gnome
    backup_guake
    backup_python_packages
    backup_repositories_config &> /dev/null
    backup_snap_packages
    backup_symbolic_links
}

function backup_it() {
    cp --preserve=all --recursive $1 $1_$(date +"%Y%m%d%H%M%S%N")
}
