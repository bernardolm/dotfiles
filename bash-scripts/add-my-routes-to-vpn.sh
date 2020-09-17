function add_my_routes_to_vpn() {
    ADDRS=$(<$SYNC_PATH/scripts/domains-to-route-to-vpn.txt)

    echo -e "Adding routes:\n${ADDRS[@]}\n\n"

    TUNNEL_ADDR=$(ip -o -4 addr list tun0 | awk '{print $4}')

    get_addrs() {
        echo $(nslookup $1 | grep Address | grep -v '#' | cut -d: -f2)
    }

    format_network() {
        echo $(echo $1 | cut -d. -f1-3).0/24
    }

    add_route() {
        SOURCE_NET=$(format_network $1)
        CMD="sudo ip route add $SOURCE_NET via $TUNNEL_ADDR"
        $CMD
    }

    do_work() {
        for i in $ADDRS; do
            echo "routing $i to tun0"
            IP_ADDRS=$(get_addrs $i)
            for j in $IP_ADDRS; do
                add_route $j
            done
        done
    }

    do_work
}
