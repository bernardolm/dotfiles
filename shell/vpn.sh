function vpn_ip() {
    ip -j address | jq '.[] | .addr_info | .[] | select(.family == "inet") | select(.label ==  "'$1'") | .local' | sed 's/"//g'
}
