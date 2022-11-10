function conky_kill() {
    killall -9 conky 2>/dev/null
}

function conky_start() {
    conky -q -d --font='NovaMono:size=12'
}

function conky_instances() {
    ps auxwf | grep -v grep | grep '_ conky' | wc -l | bc
}

function conky_restart() {
    local instaces
    instaces=$(conky_instances)
    notify-send "conky (re)starting" "$(conky_instances) were running."
    conky_kill
    sleep 1
    conky_start
}
