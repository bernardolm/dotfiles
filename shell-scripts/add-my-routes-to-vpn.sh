add_my_routes_to_vpn () {
    echo -e "adding my routes do active VPN 🛡️"

    TUNNEL_ADDR=$(ip -o -4 addr list tun0 | awk '{print $4}')
    echo -e "VPN address is ${TUNNEL_ADDR}"

    get_addrs() {
        echo $(nslookup $1 | grep Address | grep -v '#' | cut -d: -f2)
    }

    format_network() {
        echo $(echo $1 | cut -d. -f1-3).0/24
    }

    add_route() {
        SOURCE_NET=$(format_network $1)
        CMD="sudo ip route add $SOURCE_NET via $TUNNEL_ADDR"
        $(CMD)
    }

    while read i; do
        IP_ADDRS=$(get_addrs $i)
        if [[ "$IP_ADDRS" == "" ]]; then
            echo -e "🔴 addr $i isn't active, exiting..."
            continue
        fi

        IP_ADDRS_ARR=($(echo $IP_ADDRS | tr " " "\n"))
        for j in "${IP_ADDRS_ARR[@]}"; do
            echo -e "🔵 routing $j from $i to $TUNNEL_ADDR"
            add_route $j
            if [[ "$?" == "1" ]]; then
                echo -e "🔴 fail to route"
                continue
            fi
            echo -e "🟢 route complete"
        done
        IP_ADDRS=/dev/nill
    done <$SYNC_PATH/scripts/domains-to-route-to-vpn.txt
}
