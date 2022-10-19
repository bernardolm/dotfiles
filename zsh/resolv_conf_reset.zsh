function resolv_conf_reset() {
    local resolv_conf="`cat $SYNC_PATH/etc/resolv.conf`"
    sudo cp $SYNC_PATH/etc/resolv.conf /etc/resolv.conf
    docker exec -it ns0 sh -c "echo \"$resolv_conf\" > /etc/resolv.conf"
}
