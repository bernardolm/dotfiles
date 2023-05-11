#!/usr/bin/env bash

# How to call?
# wget -q -O - https://raw.githubusercontent.com/bernardolm/dotfiles/master/bash/scripts/dns_local_setup.sh | bash
# P.S.: pristine Ubuntu linux don't come with curl, but wget.
#
# Dev notes:
# you can call `python3 -m http.server` from dns_local_setup.sh file path to serve ir by http on port 8000.
# wget -q -O - http://192.168.1.2:8000/dns_local_setup.sh | bash

function dns_local_setup() {
    local container_name="${CONTAINER_NAME:-ns1}"
    local custom_fallback_dns="${CUSTOM_FALLBACK_DNS-:}"
    local domain="${DOMAIN:-hud}"
    local image_name="ruudud/devdns"
    local naming="unsafe"
    local path_to_clone="${WORKSPACE_USER:-"$HOME/.devdns"}"
    # local prohibited_dns="${PROHIBITED_DNS:-'1.1.1.1,1.1.0.0,8.8.8.8,8.8.4.4'}"

    local gateway_ip
    gateway_ip=$(ip route show | grep -i 'default via' | awk '{ printf $3 }' | head -1)

    local has_curl
    has_curl=$(command -v curl &>/dev/null && echo "yes")

    local has_docker
    has_docker=$(command -v docker &>/dev/null && echo "yes")

    function sudo_advice() {
        printf "> ⚠ Your super password (sudo) is required.\n"
        tput sc
        sudo ls &>/dev/null
        tput rc; tput el
    }

    function local_dns_instances_running() {
        printf "> Listing docker containers using image %s.\n" "$image_name"
        docker ps -a -q --filter "ancestor=${image_name}:latest"
    }

    function kill_53_port_user() {
        printf "> Killing process using port 53.\n"
        sudo lsof -t -i:53 | while read -r pid; do
            sudo kill -9 "$pid"
        done
        sudo killall -HUP dnsmasq 2>/dev/null
    }

    function remove_local_dns_instances() {
        printf "> Removing DNS docker containers.\n"
        local_dns_instances_running | tail -n +3 | while read -r container_id; do
            printf "%s" "$container_id"
            docker stop "$container_id" 2>/dev/null
            docker rm "$container_id" 2>/dev/null
        done
    }

    function build_local_dns_image() {
        printf "> Building %s docker image.\n" "$image_name"
        docker build \
            --quiet \
            --force-rm \
            -f "$path_to_clone/Dockerfile" \
            -t "$image_name" \
            "$path_to_clone"
    }

    function show_resolv_conf() {
        cat < /etc/resolv.conf | grep -v -e '^#' | grep -v -e '^\s*$' | grep --color=never 'nameserver'
    }

    function show_network_manager_conf() {
        cat < /etc/NetworkManager/NetworkManager.conf | grep -v -e '^#' | grep -v -e '^\s*$' | grep --color=never 'dns=dnsmasq'
    }

    function add_fallback_dns() {
        printf "> Configuring DNS resolver fallback\n"
        has_gateway_ip=$(cat < /etc/resolv.conf | grep -v -e '^#' | grep -c "$gateway_ip")

        printf "  Your current resolv.conf has\033[1;36m"
        show_resolv_conf
        printf "\033[0m"

        if [[ "$has_gateway_ip" == "0" ]]; then
            to_add="nameserver $gateway_ip\t# current DNS from your router gateway"
            printf "%s" "$to_add" | sudo tee -a /etc/resolv.conf &>/dev/null

            printf "  Your changed resolv.conf is\033[1;36m"
            show_resolv_conf
            printf "\033[0m"
        fi

        if [[ -n "$custom_fallback_dns" ]]; then
            to_add="nameserver $custom_fallback_dns\t# your custom DNS"
            printf "%s" "$to_add" | sudo tee -a /etc/resolv.conf &>/dev/null

            printf "  Your changed resolv.conf is\033[1;36m"
            show_resolv_conf
            printf "\033[0m"
        fi
    }

    function test_hosts() {
        printf "> Testing name resolver.\n"

        printf "   Created docker container.\n"
        dig "$container_name.$domain" | grep --color=never "$container_name.$domain"

        printf "  Some internet name.\n"
        dig 'www.google.com' | grep --color=never 'www.google.com'

        printf "  Some local network name.\n"
        dig 'spinnaker.hucloud.com.br' | grep --color=never 'spinnaker.hucloud.com.br'
    }

    function start_local_dns() {
        printf "> Starting docker container %s.\n" "$container_name"

        mkdir -p "$HOME/.$container_name/dnsmasq-hosts.d"

        docker run -d \
            --name="$container_name" \
            --restart=always \
            -e DNS_DOMAIN="$domain" \
            -e FALLBACK_DNS="$gateway_ip" \
            -e NAMING="$naming" \
            -p 53:53/udp \
            -v /etc/resolv.conf:/mnt/resolv.conf \
            -v /var/run/docker.sock:/var/run/docker.sock:ro \
            "$image_name"

        docker logs -n-1 "$container_name"
    }

    function install_docker () {
        printf "  Installing docker.\n"
        printf "  Your can check https://docs.docker.com/engine/install/ubuntu/ for more details.\n"
        printf "  And is important check https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user too.\n"
        printf "  Now calling install script from official docker site.\n\n"
        curl -fsSL "https://get.docker.com" -o /tmp/get-docker.sh || return 1
        sudo sh /tmp/get-docker.sh || return 1
    }

    function setup_docker() {
        printf "> Executing post install docker.\n"
        getent group docker &>/dev/null || sudo groupadd docker &>/dev/null || return 1
        sudo usermod -aG docker "$USER" || return 1
        newgrp docker || return 1
        sudo apt-get install -y uidmap &>/dev/null && dockerd-rootless-setuptool.sh install 1>/dev/null || return 1
    }

    function check_dependencies() {
        printf "> Checking dependencies.\n"

        if [ "$has_curl" == "yes" ]; then
            printf "  Curl OK.\n"
        else
            printf "  Installing curl.\n"
            sudo apt-get install curl --yes 1>/dev/null || return 1
        fi

        if [ "$has_docker" == "yes" ]; then
            printf "  Docker installed.\n"
        else
            install_docker || return 1
        fi

        if docker run hello-world &>/dev/null; then
            printf "  Permission to run docker OK.\n"
        else
            setup_docker || return 1
        fi

        [ "$has_docker" == "yes" ] && docker run hello-world &>/dev/null && printf "  Docker OK.\n"

        printf "  All dependencies OK.\n"
    }

    function check_user_workspace() {
        if [ ! -d "$path_to_clone" ]; then
            mkdir -p "$path_to_clone"
        fi
    }

    # reset
    printf "> Starting DNS setup.\n"
    sudo_advice
    check_dependencies || return
    # check_user_workspace || return
    # local_dns_instances_running
    # remove_local_dns_instances
    # build_local_dns_image
    # start_local_dns
    # add_fallback_dns
    # sleep 1
    # test_hosts
    printf "> DNS setup finished.\n"
}

trap "echo; exit" INT

dns_local_setup
