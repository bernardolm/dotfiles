function backup_python_packages() {
    mv $SYNC_PATH/python-packages/$(hostname)_current.txt $SYNC_PATH/python-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    pip freeze | grep -v 'git@' > $SYNC_PATH/python-packages/$(hostname)_current.txt
}
