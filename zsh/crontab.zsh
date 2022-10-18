function backup_crontab() {
    mkdir -p $SYNC_PATH/crontab/
    [ -f $SYNC_PATH/crontab/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/crontab/$(hostname)_current.txt $SYNC_PATH/crontab/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    crontab -l > $SYNC_PATH/crontab/$(hostname)_current.txt
}