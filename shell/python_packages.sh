function backup_python_packages() {
    mkdir -p $SYNC_PATH/python-packages/
    mv $SYNC_PATH/python-packages/$(hostname)_current.txt $SYNC_PATH/python-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    pip freeze | grep '==' > $SYNC_PATH/python-packages/$(hostname)_current.txt.tmp
}

function restore_python_packages() {
    local 'file'
    file=$(last_backup_version python-packages txt)

    /bin/cat $file | /bin/awk -F'==' '{print $1}' ORS=' ' | xargs pip3 install
}
