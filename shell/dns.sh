function dns_local_reset() {
    sudo kill -9 $(sudo lsof -t -i:53) || true
    docker stop ns0 || true
    docker rm ns0 || true
    sudo killall -HUP dnsmasq || true
    docker run -d \
        --name ns0 \
        --restart unless-stopped \
        -e DNS_DOMAIN=hud \
        -p 53:53/udp \
        -v /etc/resolv.conf:/mnt/resolv.conf \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        ruudud/devdns
}
