function dns_local_reset() {
    function kill_dns() {
        sudo kill -9 $(sudo lsof -t -i:53)
        docker stop ns0
        docker rm ns0
        sudo killall -HUP dnsmasq
    }

    kill_dns 2>/dev/null

    local image_name="ruudud/devdns"
    local root_path="$WORKSPACE_USER/devdns"

    docker build \
        --force-rm \
        -f $root_path/Dockerfile \
        -t $image_name \
        .

    docker run -d \
        --name ns0 \
        --restart unless-stopped \
        -e DNS_DOMAIN=hud \
        -e NAMING=pristine \
        -p 53:53/udp \
        -v /etc/resolv.conf:/mnt/resolv.conf \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v $root_path/run.sh:/run.sh \
        $image_name
}
