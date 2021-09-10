function add_vpn_custom_routes() {
    function init_file() {
        if [ -f $SYNC_PATH/vpn-custom-routes/current.csv ]; then
            mv $SYNC_PATH/vpn-custom-routes/current.csv \
                $SYNC_PATH/vpn-custom-routes/$1.csv
        fi
        echo "host;up at;down at" | tee $SYNC_PATH/vpn-custom-routes/current.csv >/dev/null
    }

    function get_addrs() {
        local CMD="nslookup $1 | grep Address | grep -v '#' | cut -d: -f2"
        eval $CMD 2>/dev/null
    }

    function format_network() {
        echo $(echo $1 | cut -d. -f1-3).0/24
    }

    function add_route() {
        local SOURCE_NET=$(format_network $1)
        local CMD="sudo ip route add $SOURCE_NET via $2"
        eval $CMD 2>/dev/null
    }

    echo "adding my routes do active VPN 🛡️"

    local MOMENT=$(date --rfc-3339=seconds)
    local NOW=$(date +"%Y%m%d%H%M%S")
    local TUNNEL_ADDR=`tun0_ip`

    init_file $NOW

    echo "VPN address is ${TUNNEL_ADDR}"

    while read line; do
        [[ "$line" == host\;* ]] && continue

        if [[ `ps -p $$ -ocomm=` == "zsh" ]]; then
            parts=("${(@s/;/)line}")
            host=${parts[1]}
            up_at=${parts[2]}
            down_at=${parts[3]}
        else
            IFS=';' read -r -a parts <<<"$line"
            host=${parts[0]}
            up_at=${parts[1]}
            down_at=${parts[2]}
        fi

        if [[ "$down_at" != "" ]]; then
            echo $line | tee -a $SYNC_PATH/vpn-custom-routes/current.csv >/dev/null
            continue
        fi

        IP_ADDRS=$(get_addrs $host)

        if [[ "$IP_ADDRS" == "" ]]; then
            echo "🔴 addr $host is down, exiting..."
            echo $host";"$up_at";"$MOMENT | tee -a $SYNC_PATH/vpn-custom-routes/current.csv >/dev/null
            continue
        fi

        echo $host";"$MOMENT";" | tee -a $SYNC_PATH/vpn-custom-routes/current.csv >/dev/null

        IP_ADDRS_ARR=($(echo $IP_ADDRS | tr " " "\n"))

        for j in "${IP_ADDRS_ARR[@]}"; do
            echo "🔵 routing $j from $host to $TUNNEL_ADDR"
            add_route $j $TUNNEL_ADDR
            if [[ "$?" == "1" ]]; then
                echo "🔴 fail to route"
                continue
            fi
            echo "🟢 route complete"
        done

        IP_ADDRS=/dev/null
    done < $SYNC_PATH/vpn-custom-routes/$NOW.csv
}
