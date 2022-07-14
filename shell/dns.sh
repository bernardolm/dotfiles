function dns_local_reset() {
    local container_name="ns0"
    local domain="hud"
    local image_name="ruudud/devdns"
    local naming="unsafe"
    local root_path="$WORKSPACE_USER/devdns"

    function running() {
        docker ps -a -q --filter ancestor=${image_name}:latest
    }

    function kill_53_port_user() {
        sudo lsof -t -i:53 | while read pid; do
            sudo kill -9 $pid
        done
        sudo killall -HUP dnsmasq 2>/dev/null
    }

    function remove() {
        docker stop $container_name
        docker rm $container_name
    }

    function remove_all() {
        running | while read container_id; do
            docker stop $container_id
            docker rm $container_id
        done
    }

    function build() {
        docker build \
            --force-rm \
            -f $root_path/Dockerfile \
            -t $image_name \
            $root_path
    }

    function start() {
        docker run -d \
            --name $container_name \
            --restart unless-stopped \
            -e DNS_DOMAIN=$domain \
            -e NAMING=$naming \
            -p 53:53/udp \
            -v /etc/resolv.conf:/mnt/resolv.conf \
            -v /var/run/docker.sock:/var/run/docker.sock:ro \
            -v $root_path/run.sh:/run.sh \
            $image_name
    }

    echo "Reset local DNS at $(date)"
    remove_all
    kill_53_port_user
    start
}
