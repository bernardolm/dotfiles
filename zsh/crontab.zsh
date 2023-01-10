function crontab_backup() {
    mkdir -p $SYNC_DOTFILES/crontab/
    [ -f $SYNC_DOTFILES/crontab/$(hostname)_current.txt ] && mv \
        $SYNC_DOTFILES/crontab/$(hostname)_current.txt $SYNC_DOTFILES/crontab/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    crontab -l > $SYNC_DOTFILES/crontab/$(hostname)_current.txt
}
