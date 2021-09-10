function backup_python_packages() {
    mkdir -p $SYNC_PATH/python-packages/
    mv $SYNC_PATH/python-packages/$(hostname)_current.txt $SYNC_PATH/python-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    pip freeze | grep -v 'git@' > $SYNC_PATH/python-packages/$(hostname)_current.txt
}

function restore_python_packages() {
    /bin/cat $SYNC_PATH/python_packages/$(hostname)_current.txt | grep -v git@ | xargs pip install
}
