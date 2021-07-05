function backup_python_packages() {
    pip freeze | grep -v 'git@' > "$SYNC_PATH/python_packages_$(hostname)"
}
