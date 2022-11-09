function vpn_get_ips() {
    local cmd="nslookup $1 | grep -A 10 'Non-authoritative answer' | \
        grep Address | cut -d' ' -f2"
    # echo "$cmd"
    eval $cmd
}

function vpn_ip_subnet() {
    echo $(echo $1 | cut -d. -f1-3).0/24
}

function vpn_ip_route_add() {
    local source_net=$(vpn_ip_subnet $1)
    local cmd="sudo ip route add $source_net via $2"
    # echo "$cmd"
    eval $cmd 2>/dev/null
}

function vpn_ip() {
    ip -o addr show up type ppp | /bin/awk '{print $4}'
}

function vpn_add_route() {
    local host=$1
    local ips=($(vpn_get_ips $host))
    local local_vpn_ip=${2:=$(vpn_ip)}

    vpn_get_ips $host | while read ip; do
        vpn_ip_route_add "$ip" "$local_vpn_ip"
    done
}

function vpn_add_routes() {
    local now=$(date +"%Y%m%d%H%M%S")

    local file=${1:=$(last_backup_version vpn-routes csv)}
    [ -z "$file" ] && echo "no vpn-routes file found" && return
    local new_file=$(echo $file | sed "s/[0-9]\+/${now}/g")
    local total=$(wc -l < "$file")

    echo "🛡️ adding my routes from $file to VPN ($total)"

    local local_vpn_ip=${2:=$(vpn_ip)}
    [ -z $local_vpn_ip ] && echo "VPN IP not found" && return

    local count=0

    sudo echo "you give root permission"

    cat $file | while read line; do
        ((count=count+1))

        if [[ `which_shell` == "zsh" ]]; then
            local parts=("${(@s/;/)line}")
            local host=${parts[1]}
            local up_at=${parts[2]}
            local down_at=${parts[3]}
        else
            IFS=';' read -r -a parts <<<"$line"
            local host=${parts[0]}
            local up_at=${parts[1]}
            local down_at=${parts[2]}
        fi

        [ "$down_at" != "" ] \
            && echo $line | tee -a $new_file &>/dev/null \
            && continue

        vpn_add_route $host

        if [ $? -eq 0 ]; then
            echo $host";"$now";" | tee -a $new_file &>/dev/null
        else
            echo $host";"$up_at";"$now | tee -a $new_file &>/dev/null
        fi

        [ `command -v progress_bar` ] && progress_bar $count $total "$host"
    done
}
