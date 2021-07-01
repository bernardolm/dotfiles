function backup_python_packages() {
    pip freeze > "$SYNC_PATH/backup_of_my_python_packages"
}
