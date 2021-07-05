function backup_python_packages() {
    pip freeze > "$SYNC_PATH/python_packages_$(hostname)"
}
