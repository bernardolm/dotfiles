function kill_by_port() {
    sudo kill -9 $(sudo lsof -t -i:$1)
}
