conky_instances=$(ps auxwf | grep -v grep | grep '_ conky' | wc -l)
$DEBUG_SHELL && notify-send "conky" "$conky_instances was instances started"

[ $(echo $conky_instances | bc) -gt 1 ] && \
    echo "many conkys are started, killing them" && \
    kill-conky && \
    sleep 1 && \
    conky -q
[ $(echo $conky_instances | bc) -eq 0 ] && \
    echo "starting conky" && \
    conky -q
