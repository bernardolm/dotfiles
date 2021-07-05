function restore_python_packages() {
    /bin/cat "$SYNC_PATH/python_packages_$(hostname)" | grep -v git@ | xargs pip install
}
