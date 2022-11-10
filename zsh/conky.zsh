function conky_kill() {
    killall -9 conky 2>/dev/null
}

function conky_start() {
    conky -q -d --font='NovaMono:size=9'
}

function conky_restart() {
    conky_kill
    conky_start
}

function conky_instances() {
    ps auxwf | grep -v grep | grep '_ conky' | wc -l | bc
}

function conky_init() {
    local instaces
    instaces=$(conky_instances)

    function start() {
        notify-send "conky (re)starting" "$(conky_instances) were running."
        conky_restart
        sleep 360
        start
    }

    start &
}
