function restore_python_packages() {
    /bin/cat "$SYNC_PATH/backup_of_my_python_packages" | grep -v git@ | xargs pip install
}
