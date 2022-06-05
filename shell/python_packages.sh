function backup_python_packages() {
    mkdir -p $SYNC_PATH/python-packages/
    if [ -f "$SYNC_PATH/python-packages/$(hostname)_current.txt" ]; then
        mv $SYNC_PATH/python-packages/$(hostname)_current.txt $SYNC_PATH/python-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    fi
    pip freeze | grep '==' > $SYNC_PATH/python-packages/$(hostname)_current.txt.tmp
}

function restore_python_packages() {
    [[ $(dpkg -l swig | grep -c 'swig' | bc) -eq 0 ]] && sudo apt install swig
    [[ $(dpkg -l libgpgme-dev | grep -c 'libgpgme-dev' | bc) -eq 0 ]] && sudo apt install swig

    local 'file'
    file=$(last_backup_version python-packages txt)

    /bin/cat $file | /bin/awk -F'==' '{print $1}' ORS=' ' | xargs pip3 install
}
