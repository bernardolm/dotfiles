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

    local nameservers=(`/bin/cat /etc/resolv.conf | /bin/grep ^nameserver | /bin/awk '{print $2}' | uniq`)
    local nameserversJson=`jq --compact-output --null-input '$ARGS.positional' --args "${nameservers[@]}"`
    echo "nameserversJson=${nameserversJson}"

    echo "recreating docker daemon json"
    echo '{"debug":true,"bip":"'${nameservers[1]}'/24","dns":'${nameserversJson}'}' | \
        sudo tee /etc/docker/daemon.json > /dev/null
    cat /etc/docker/daemon.json
    sleep 1

    if [ $HAS_DOCKER_SERVICE -gt 0 ]; then
        echo "restarting service"
        sudo systemctl restart --no-pager docker
        sleep 2

        echo "displaying service status"
        sudo systemctl status --no-pager docker
    fi

    echo "bye!"
}
