DOCKER=$(which docker)
DOCKER0_IP=$(ip r | grep docker0 | awk '{print $$9}')

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
    echo 'stopping docker containers'
    check_docker_install || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo 'stopping '$id
        docker stop ${id} || continue
    done
}

function sanitize_docker_containers() {
    echo 'removing docker containers'
    check_docker_install || return true
    for id in $(eval $DOCKER_CONTAINERS); do
        echo 'removing '$id
        docker rm ${id} || continue
    done
}

function sanitize_docker_images() {
    echo 'removing docker images'
    check_docker_install || return true
    for id in $(eval $DOCKER_IMAGES); do
        echo 'removing '$id
        docker rmi ${id} || continue
    done
}

function sanitize_docker_untagged() {
    echo 'removing untagged docker images'
    check_docker_install || return true
    for id in $(eval $DOCKER_IMAGES_DANGLING); do
        echo 'removing '$id
        docker rmi ${id} || continue
    done
}

function sanitize_docker() {
    stop_docker_containers
    sanitize_docker_containers
    sanitize_docker_untagged
    sanitize_docker_images
}

function sanitize_docker_logs() {
    echo 'removing docker logs'
    check_docker_install || return true
    for container_id in $(eval $DOCKER_CONTAINERS); do
        echo 'catching '$container_id' log path'
        file=$($DOCKER inspect --format='{{.LogPath}}' $container_id)
        echo 'container '$container_id' log file in '$file', truncating'
        sudo sh -c "truncate -s 0 $file"
        echo 'done to container '$container_id
    done
}

function give_me_back_my_docker() {
    echo 'recovering docker app control'
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

function sanitize_docker_network() {
    echo "reseting docker network config"
    if [[ "$DOCKER0_IP" != "" ]]; then
        sudo ip addr del dev docker0 $DOCKER0_IP/16
        sudo ip link delete docker0
    fi
}

function sanitize_docker_install() {
    echo "removing docker installation"

    if [[ $(check_docker_running) -eq 1 ]]; then
        echo "docker is running..."

        sanitize_docker

        docker network prune --force
        docker system prune --force

        sudo service docker stop

        while [[ $(check_docker_running) -eq 1 ]]; do
            echo 'waiting docker be stopped...'
            sleep 1
        done
    fi

    sudo apt purge '^docker' '^containerd' --yes
    sudo apt autoremove --purge --yes

    sanitize_docker_config_files
    sanitize_docker_network
}

function install_docker() {
    echo "installing docker"
    check_docker_install && return true

    sudo apt install docker-ce docker-compose --yes

    sudo chown $USER:$USER /home/$USER/.docker -R
    sudo chmod g+rwx $HOME/.docker -R
    sudo groupadd docker || true
    sudo usermod -aG docker $USER || true
    newgrp docker

    sudo systemctl enable docker
}

function reset_docker() {
    echo "reseting docker"
    sanitize_docker_install
    install_docker
    install_dockerdns
}
