#!/bin/bash

# amixer -q -D pulse sset Master toggle
# amixer -q -D pulse sset Capture toggle

[ `aseqdump -l | grep LPD8 | wc -l | bc` == 0 ] && echo "LPD8 not found" && exit 1

function mic_on() {
    pacmd set-source-mute 2 0
    mic_state
}

function mic_muted() {
    pacmd set-source-mute 2 1
    mic_state
}

function mic_state() {
    state=`pacmd list-sources | grep -e 'index' -e 'muted:' | sed -n -e '/index: 2/,$p' | head -n2 | tail -n1 | grep yes >/dev/null && echo muted || echo on`
    icon='audio-input-microphone-symbolic'
    if [[ "$state" == "muted" ]]; then icon='audio-input-microphone-muted-symbolic'; fi
    # notify-send --hint=int:transient:1 -i $icon "mic is $state"
    echo "mic is $state"
}

function keep_mic_muted() {
    mic_muted
    sleep 10
    keep_mic_muted
}

keep_mic_muted &

# Use aseqdump -l to find midi device and aseqdump -p "The midi device name" to listen and know notes of each button
aseqdump -p "LPD8" | \
while IFS=" ," read src ev1 ev2 ch label1 data1 label2 data2 rest; do
    # killall notify-osd; notify-send -i "audio-input-microphone" "summary" "body $ev1 $ev2 $data1";;
    case "$ev1 $ev2 $data1" in
        "Note on 40" ) mic_on;;
        "Note off 40" ) mic_muted;;
    esac
done
