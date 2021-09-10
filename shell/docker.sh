DOCKER=$(which docker)
DOCKER_CONTAINERS="$DOCKER ps -aq"
DOCKER_IMAGES_DANGLING="$DOCKER images -q -f 'dangling=true'"
DOCKER_IMAGES="$DOCKER images -aq"

function check_docker_install() {
    command -v docker >/dev/null 2>&1
}

function check_docker_running() {
    systemctl is-active --quiet docker && echo 1
}

function stop_docker_containers() {
    echo "stopping docker containers"
    check_docker_install || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo "stopping $id"
        docker stop ${id} || continue
    done
}

function sanitize_docker_containers() {
    echo "removing docker containers"
    check_docker_install || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo "removing $id"
        docker rm ${id} || continue
    done
}

function sanitize_docker_images() {
    echo "removing docker images"
    check_docker_install || return true
    for id in $(eval $DOCKER_IMAGES); do
        echo "removing $id"
        docker rmi ${id} || continue
    done
}

function sanitize_docker_untagged() {
    echo "removing untagged docker images"
    check_docker_install || return true
    for id in $(eval $DOCKER_IMAGES_DANGLING); do
        echo "removing $id"
        docker rmi ${id} || continue
    done
}

function sanitize_docker_content() {
    echo "removing docker content"
    check_docker_install || return true
    stop_docker_containers
    sanitize_docker_containers
    sanitize_docker_untagged
    sanitize_docker_images
}

function sanitize_docker_logs() {
    echo "removing docker logs"
    check_docker_install || return true
    for container_id in $(eval $DOCKER_CONTAINERS); do
        echo "catching $container_id log path"
        file=$($DOCKER inspect --format="{{.LogPath}}" $container_id)
        echo "container $container_id log file in $file, truncating"
        sudo sh -c "truncate -s 0 $file"
        echo "done to container $container_id"
    done
}

function give_me_back_my_docker() {
    echo "recovering docker app control"
    check_docker_install || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        docker update --restart=no ${id}
        docker stop ${id}
    done
}

function sanitize_docker_config_files() {
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

function docker0_ip() {
    ip -j address | jq '.[] | .addr_info | .[] | select(.family == "inet") | select(.label ==  "docker0") | .local' | sed 's/"//g'
}

function sanitize_docker_local_ip() {
    echo "reseting docker network config"
    current_docker0_ip=`docker0_ip`
    if [[ "$current_docker0_ip" != "" ]]; then
        echo "docker0 network found in IP $current_docker0_ip"
        sudo ip addr del dev docker0 $current_docker0_ip/16
        sudo ip link delete docker0
    fi
}

function sanitize_docker_install() {
    echo "removing docker installation"

    if [[ $(check_docker_running) -eq 1 ]]; then
        echo "docker is running"

        sanitize_docker_content

        yes | docker system prune --all --volumes --force

        sudo service docker stop

        while [[ $(check_docker_running) -eq 1 ]]; do
            echo "waiting docker be stopped..."
            sleep 1
        done
    fi

    if [[ "$1" != "no-purge" ]]; then
        echo "purging docker installation"
        if [[ `apt list --installed 'docker*' 2>/dev/null | wc -l | bc` -gt 1 ]]; then
            echo "purging docker ubuntu package"
            sudo apt-get purge --yes '^docker' '^containerd' runc > /dev/null
            sudo apt-get autoremove --purge --yes > /dev/null
        fi
    fi

    sanitize_dockerdns_vestiges
    sanitize_docker_config_files
    sanitize_docker_local_ip
}

function install_docker() {
    echo "installing docker"

    if [[ `apt list --installed '*docker*' 2>/dev/null | wc -l | bc` -le 1 ]]; then
        echo "installing docker ubuntu package"
        sudo apt-get install --yes docker-ce docker-ce-cli containerd.io
    fi

    if [[ -d $HOME/.docker ]]; then
        sudo chown $USER:$USER $HOME/.docker -R
        sudo chmod g+rwx $HOME/.docker -R
    fi

    [ `/bin/cat /etc/group | grep -c docker | bc` -eq 0 ] && sudo groupadd docker && newgrp docker
    [ `getent group docker | grep -c $USER | bc` -eq 0 ] && sudo usermod -aG docker $USER

    sudo sysctl -w vm.max_map_count=262144
    [ `/bin/cat /etc/sysctl.conf | grep -c max_map_count | bc` -eq 0 ] && (echo "\nvm.max_map_count = 262144" | sudo tee -a /etc/sysctl.conf)

    sudo systemctl restart docker

    sudo systemctl enable docker
}

function reset_docker() {
    echo "reseting docker"
    sanitize_docker_install no-purge
    install_docker
    install_dockerdns
}
