function backup_crontab() {
    mv $SYNC_PATH/crontab/$(hostname)_current.txt $SYNC_PATH/crontab/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    crontab -l > $SYNC_PATH/crontab/$(hostname)_current.txt
}
