function reset_docker_daemon_config() {
    echo "starting docker daemon json sanitize..."

    local HAS_DOCKER_SERVICE=1

    [ ! -f /lib/systemd/system/docker.service ] && HAS_DOCKER_SERVICE=0

    echo "docker service active? $HAS_DOCKER_SERVICE"

    if [ $HAS_DOCKER_SERVICE -gt 0 ]; then
        if [[ `/bin/cat /lib/systemd/system/docker.service | grep 'StartLimitBurst=3' | wc -l | bc` -eq 1 ]]; then
            echo "changing docker restart limit"
            sudo sed -i 's/StartLimitBurst=3/StartLimitBurst=99/g' /lib/systemd/system/docker.service
            sudo systemctl daemon-reload
        fi
    fi

    echo "recreating docker daemon json"
    echo "{\"debug\":true,\"bip\":\"172.17.0.1/24\",\"dns\":[\"172.17.0.1\",\"127.0.0.53\"]}" | \
        sudo tee /etc/docker/daemon.json > /dev/null
    sleep 2

    if [ $HAS_DOCKER_SERVICE -gt 0 ]; then
        echo "restarting service"
        sudo systemctl restart --no-pager docker
        sleep 2

        echo "displaying service status"
        sudo systemctl status --no-pager docker
    fi

    echo "bye!"
}
