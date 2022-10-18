local conky_instances=$(ps auxwf | grep -v grep | grep '_ conky' | wc -l | bc)
$DEBUG_SHELL && notify-send "conky" "$conky_instances instances running"

if [ $conky_instances -gt 1 ]; then
    notice "many conkys are started, killing them and start only one"
    killall -9 conky
    sleep 1
    conky -q -d
fi

[ $conky_instances -eq 0 ] && conky -q -d
