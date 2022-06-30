DOCKER=$(which docker)
DOCKER_CONTAINERS="$DOCKER ps -aq"
DOCKER_IMAGES_DANGLING="$DOCKER images -q -f 'dangling=true'"
DOCKER_IMAGES="$DOCKER images -aq"

function docker_install_check() {
    command -v docker &>/dev/null
}

function docker_running_check() {
    # systemctl is-active --quiet docker && echo 1
    [[ $(docker ps &>/dev/null | grep -c Cannot | bc) -eq 1 ]]
}

function docker_containers_stop() {
    echo "stopping docker containers"
    docker_install_check || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo "stopping $id"
        docker stop ${id} || continue
    done
}

function docker_containers_sanitize() {
    echo "removing docker containers"
    docker_install_check || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo "removing $id"
        docker rm ${id} || continue
    done
}

function docker_images_sanitize() {
    echo "removing docker images"
    docker_install_check || return true
    for id in $(eval $DOCKER_IMAGES); do
        echo "removing $id"
        docker rmi ${id} || continue
    done
}

function docker_untagged_sanitize() {
    echo "removing untagged docker images"
    docker_install_check || return true
    for id in $(eval $DOCKER_IMAGES_DANGLING); do
        echo "removing $id"
        docker rmi ${id} || continue
    done
}

function docker_content_sanitize() {
    echo "removing docker content"
    docker_install_check || return true
    docker_containers_stop
    docker_containers_sanitize
    docker_images_untagged_sanitize
    docker_images_sanitize
}

function docker_logs_sanitize() {
    echo "removing docker logs"
    docker_install_check || return true
    for container_id in $(eval $DOCKER_CONTAINERS); do
        echo "catching $container_id log path"
        file=$($DOCKER inspect --format="{{.LogPath}}" $container_id)
        echo "container $container_id log file in $file, truncating"
        sudo sh -c "truncate -s 0 $file"
        echo "done to container $container_id"
    done
}

function docker_give_me_back_my() {
    echo "recovering docker app control"
    docker_install_check || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        docker update --restart=no ${id}
        docker stop ${id}
    done
}

function docker_config_files_sanitize() {
    echo "removing docker install files"
    /bin/rm -rf ~/.docker
    sudo /bin/rm -rf /etc/apparmor.d/docker
    sudo /bin/rm -rf /etc/docker
    sudo /bin/rm -rf /etc/docker/daemon.json
    sudo /bin/rm -rf /etc/NetworkManager/conf.d/01_docker
    sudo /bin/rm -rf /etc/NetworkManager/dnsmasq.d/01_docker
    # sudo /bin/rm -rf /run/docker
    sudo /bin/rm -rf /usr/share/code/resources/app/extensions/docker
    sudo /bin/rm -rf /var/lib/docker
    sudo /bin/rm -rf /var/run/docker.sock
}

function docker_network_ip() {
    ip -j address | jq '.[] | .addr_info | .[] | select(.family == "inet") | select(.label ==  "docker0") | .local' | sed 's/"//g'
}

function docker_local_ip_sanitize() {
    echo "reseting docker network config"
    current_docker0_ip=`docker_network_ip`
    if [[ "$current_docker0_ip" != "" ]]; then
        echo "docker0 network found in IP $current_docker0_ip"
        sudo ip addr del dev docker0 $current_docker0_ip/24
        sudo ip link delete docker0
    fi
}

function docker_install_sanitize() {
    echo "removing docker installation"

    if [[ `docker_running_check` -eq 1 ]]; then
        echo "docker is running"

        docker_content_sanitize

        yes | docker system prune --all --volumes --force

        sudo service docker stop

        while [[ `docker_running_check` -eq 1 ]]; do
            echo "waiting docker be stopped..."
            sleep 1
        done
    fi

    if [[ "$1" != "no-purge" ]]; then
        echo "finding docker installation..."
        if [[ `docker_install_check` -eq 1 ]]; then
            echo "purging existent docker ubuntu package"
            echo "\033[0;36m"
            sudo apt-get purge '^docker' containerd runc --yes 2>/dev/null
            sudo apt-get autoremove --purge --yes
            echo "\033[0m"
        else
            echo "no docker install found"
        fi
    fi

    dockerdns_sanitize_vestiges
    docker_config_files_sanitize
    docker_local_ip_sanitize
}

function docker_install() {
    echo "installing docker"

    if [[ `docker_install_check` -eq 0 ]]; then
        echo "installing docker ubuntu package"
        echo "\033[0;36m"
        sudo apt-get install --yes docker-ce docker-ce-cli containerd.io docker-compose
        sleep 1
        sudo apt install -f
        sleep 1
        echo "\033[0m"
    fi

    if [[ -d $HOME/.docker ]]; then
        sudo chown $USER:$USER $HOME/.docker -R
        sudo chmod g+rwx $HOME/.docker -R
    fi

    [ `/bin/cat /etc/group | grep -c docker | bc` -eq 0 ] && sudo groupadd docker && newgrp docker
    [ `getent group docker | grep -c $USER | bc` -eq 0 ] && sudo usermod -aG docker $USER

    sudo sysctl -w vm.max_map_count=262144
    [ `/bin/cat /etc/sysctl.conf | grep -c max_map_count | bc` -eq 0 ] && (echo "\nvm.max_map_count = 262144" | sudo tee -a /etc/sysctl.conf)

    sudo systemctl enable docker

    sudo systemctl restart docker
}

function docker_reset() {
    echo "reseting docker"
    # docker_install_sanitize no-purge
    docker_install_sanitize
    install_docker
    install_dockerdns
}

function docker_shell() {
    IMAGE=`pwd`
    IMAGE=`basename $IMAGE`
    if [ -n "$1" ]; then
        IMAGE="$1"
    fi
    echo "Opening shell into docker '$IMAGE'..."
    docker exec -i -t "$IMAGE" /bin/sh
}

function docker_daemon_config_reset() {
    echo "starting docker daemon json sanitize..."

    [ `ifconfig docker0 | grep -c docker0` -gt 0 ] \
        && ifconfig docker0 \
        && sudo ifconfig docker0 down

    local HAS_DOCKER_SERVICE=1
    [ ! -f /lib/systemd/system/docker.service ] && HAS_DOCKER_SERVICE=0

    echo "docker service active? $HAS_DOCKER_SERVICE"

    if [ $HAS_DOCKER_SERVICE -gt 0 ]; then
        sudo systemctl stop docker

        if [[ `/bin/cat /lib/systemd/system/docker.service | grep 'StartLimitBurst=3' | wc -l | bc` -eq 1 ]]; then
            echo "changing docker restart limit"
            sudo sed -i 's/StartLimitBurst=3/StartLimitBurst=99/g' /lib/systemd/system/docker.service
            sudo systemctl daemon-reload
        fi

        echo "recreating docker daemon json"

        sudo ip link delete docker0

        # local nameservers=(`/bin/cat /etc/resolv.conf | /bin/grep '^nameserver' | /bin/awk '{print $2}' | uniq`)
        # local nameserversJson=`jq --compact-output --null-input '$ARGS.positional' --args "${nameservers[@]}"`
        # echo "nameserversJson=${nameserversJson}"
        # echo '{"debug":true,"bip":"'${nameservers[1]}'/24","dns":'${nameserversJson}'}' | \
        #     sudo tee /etc/docker/daemon.json > /dev/null

        echo '{"debug":true,"bip":"172.17.0.1/24"}' | sudo tee /etc/docker/daemon.json > /dev/null

        cat /etc/docker/daemon.json

        sudo systemctl restart docker
        sudo systemctl status docker

        [ `ifconfig docker0 | grep -c docker0` -gt 0 ] \
            && ifconfig docker0 \
            && sudo ifconfig docker0 up
    else
        echo "docker service not found"
    fi

    echo "bye!"
}
