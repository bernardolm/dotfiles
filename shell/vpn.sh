function tun0_ip() {
    ip -j address | jq '.[] | .addr_info | .[] | select(.family == "inet") | select(.label ==  "tun0") | .local' | sed 's/"//g'
}
