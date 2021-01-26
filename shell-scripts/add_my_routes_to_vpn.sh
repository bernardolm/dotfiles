function add_my_routes_to_vpn() {
    function init_tmp_file() {
        if [ -f ~/tmp/hosts-to-route-to-vpn.csv ]; then
            mv ~/tmp/hosts-to-route-to-vpn.csv \
                ~/tmp/hosts-to-route-to-vpn-$(date +%d-%m-%Y_%H-%M-%S).csv
        fi
        echo "host;up at;down at" | tee ~/tmp/hosts-to-route-to-vpn.csv >/dev/null
    }

    function save_final_file() {
        mv $SYNC_PATH/scripts/hosts-to-route-to-vpn.csv \
            $SYNC_PATH/scripts/hosts-to-route-to-vpn-$(date +%d-%m-%Y_%H-%M-%S).csv
        mv ~/tmp/hosts-to-route-to-vpn.csv \
            $SYNC_PATH/scripts/hosts-to-route-to-vpn.csv
    }

    function get_addrs() {
        echo $(nslookup $host | grep Address | grep -v '#' | cut -d: -f2)
    }

    function format_network() {
        echo $(echo $1 | cut -d. -f1-3).0/24
    }

    function add_route() {
        SOURCE_NET=$(format_network $1)
        CMD="sudo ip route add $SOURCE_NET via $TUNNEL_ADDR"
        eval $CMD
    }

    echo "adding my routes do active VPN 🛡️"

    init_tmp_file

    NOW=$(date --rfc-3339=seconds)
    TUNNEL_ADDR=$(ip -o -4 addr list tun0 | awk '{print $4}')
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
            echo "🔴 addr $host was inactivated, exiting..."
            echo $line | tee -a ~/tmp/hosts-to-route-to-vpn.csv >/dev/null
            continue
        fi

        IP_ADDRS=$(get_addrs $host)

        if [[ "$IP_ADDRS" == "" ]]; then
            echo "🔴 addr $host is down, exiting..."
            echo $host";"$up_at";"$NOW | tee -a ~/tmp/hosts-to-route-to-vpn.csv >/dev/null
            continue
        fi

        echo $host";"$NOW";" | tee -a ~/tmp/hosts-to-route-to-vpn.csv >/dev/null

        IP_ADDRS_ARR=($(echo $IP_ADDRS | tr " " "\n"))

        for j in "${IP_ADDRS_ARR[@]}"; do
            echo "🔵 routing $j from $host to $TUNNEL_ADDR"
            add_route $j
            if [[ "$?" == "1" ]]; then
                echo "🔴 fail to route"
                continue
            fi
            echo "🟢 route complete"
        done

        IP_ADDRS=/dev/null
    done <$SYNC_PATH/scripts/hosts-to-route-to-vpn.csv

    save_final_file
}
