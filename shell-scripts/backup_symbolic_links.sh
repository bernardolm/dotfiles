function backup_symbolic_links() {
    mv $SYNC_PATH/symbolic-links/current.txt $SYNC_PATH/symbolic-links/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    find / -type l -ls 2>/dev/null | awk -F" " '{print $13";"$11}\' | grep '/home/'$USER |
        grep -iv '.cache' |
        grep -iv '.dropbox-dist' |
        grep -iv '.mozilla' |
        grep -iv '.oh-my-zsh/' |
        grep -iv '.old-gnome-config' |
        grep -iv '.wine' |
        grep -iv '/.themes/' |
        grep -iv '/.zinit/' |
        grep -iv '/app/' |
        grep -iv '/java.base/' |
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
        grep -iv 'share/Trash' |
        grep -iv 'snap' |
        grep -iv 'studio3t/jre' |
        grep -iv 'venv/' |
        grep -iv 'webkitgtk' |
        grep -iv $GITHUB_ORG \
            >> $SYNC_PATH/symbolic-links/current.txt
}
