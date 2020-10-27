function backup_my_sym_links() {
    find / -type l -ls | awk -F" " '{print "/bin/rm $11 && ln -sf " $13,$11}\' | grep '/home/'$USER |
        grep -iv '.mozilla' |
        grep -iv '.oh-my-zsh/' |
        grep -iv '.wine' |
        grep -iv '/.themes/' |
        grep -iv '/.zinit/' |
        grep -iv '/app/' |
        grep -iv '/Dropbox' |
        grep -iv '/proc' |
        grep -iv '/tmp/' |
        grep -iv '/workspaces/' |
        grep -iv 'applications-merged' |
        grep -iv 'arduino' |
        grep -iv 'chrome' |
        grep -iv 'darwin' |
        grep -iv 'genymotion' |
        grep -iv 'gnome-shell/extensions/' |
        grep -iv 'gopath' |
        grep -iv 'linux' |
        grep -iv 'lutris' |
        grep -iv 'node_modules' |
        grep -iv 'Rambox' |
        grep -iv 'snap' |
        grep -iv 'venv/' |
        grep -iv 'webkitgtk' |
        grep -iv $GITHUB_ORG \
            >>$SYNC_PATH/scripts/bash-scripts/restore-my-sym-links.sh
}
