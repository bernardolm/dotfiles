function dns_systemd_stop() {
    if [ $(sudo systemctl status systemd-resolved | grep 'Active: active' | wc -l | bc) -gt 0 ]; then
        sudo systemctl stop systemd-resolved
        sudo systemctl disable systemd-resolved
    fi
}

function dns_local_reset() {
    local container_name="ns1"
    local domain="hud"
    local image_name="ruudud/devdns"
    local naming="unsafe"
    local root_path="${WORKSPACE_USER}/devdns"
    local gateway_ip=$(ip route show | grep -i 'default via'| awk '{print $3 }' | head -1)

    function running() {
        docker ps -a -q --filter ancestor=${image_name}:latest
    }

    function kill_53_port_user() {
        sudo lsof -t -i:53 | while read -r pid; do
            sudo kill -9 ${pid}
        done
        sudo killall -HUP dnsmasq 2>/dev/null
    }

    function remove() {
        docker stop $container_name
        docker rm $container_name
    }

    function remove_all() {
        running | while read -r container_id; do
            docker stop ${container_id} 2>/dev/null
            docker rm ${container_id} 2>/dev/null
        done
    }

    function build() {
        docker build \
            --quiet \
            --force-rm \
            -f ${root_path}/Dockerfile \
            -t ${image_name} \
            ${root_path}
    }

    function fallback() {
        local has_gateway_ip=$(cat /etc/resolv.conf | grep -c ${gateway_ip})

        echo "\n${MINTGREEN_BG}${FOREST}Current resolv.conf${NC}\n"
        cat /etc/resolv.conf
        sleep 1

        if [[ ${has_gateway_ip} == "0" ]]; then
            local to_add="nameserver ${gateway_ip}\t# Current DNS from your router gateway"
            echo "${to_add}" | sudo tee -a /etc/resolv.conf &>/dev/null

            echo "\n${MINTGREEN_BG}${FOREST}Fixed resolv.conf${NC}\n"
            cat /etc/resolv.conf
        fi
    }

    function test() {
        echo "${CYAN}"
        sleep 1
        dig ${container_name}.${domain} | grep ${container_name}.${domain}
        dig www.google.com | grep www.google.com
        echo "${NC}"
    }

    function start() {
        mkdir -p $HOME/.${container_name}/dnsmasq-hosts.d

        docker run -d \
            --name=${container_name} \
            --restart=always \
            -e DNS_DOMAIN=${domain} \
            -e FALLBACK_DNS=${gateway_ip} \
            -e NAMING=${naming} \
            -p 53:53/udp \
            -v /etc/resolv.conf:/mnt/resolv.conf \
            -v /var/run/docker.sock:/var/run/docker.sock:ro \
            ${image_name}

        docker logs -n-1 ${container_name}
    }

    reset
    echo "\n${MINTGREEN_BG}${FOREST}Reset local DNS at $(date)${NC}\n"
    remove_all
    build
    dns_systemd_stop
    start
    fallback
    echo "\n${MINTGREEN_BG}${FOREST}Local DNS started at $(date), now testing with dig...${NC}\n"
    test

    # grep -v ${gateway_ip} /etc/resolv.conf | sudo tee /etc/resolv.conf
}