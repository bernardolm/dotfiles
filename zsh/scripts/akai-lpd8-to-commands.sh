#!/usr/bin/env zsh

# amixer -q -D pulse sset Master toggle
# amixer -q -D pulse sset Capture toggle

[ `aseqdump -l | grep -c LPD8 | bc` == 0 ] && echo "LPD8 not found" && exit 1

# Use aseqdump -l to find midi device and aseqdump -p "The midi device name" to listen and know notes of each button
aseqdump -p "LPD8" | \
while IFS=" ," read src ev1 ev2 ch label1 data1 label2 data2 rest; do
    # killall notify-osd; notify-send -i "audio-input-microphone" "summary" "body $ev1 $ev2 $data1";;
    case "$ev1 $ev2 $data1" in
        "Note on 40" ) mic_on;;
        "Note off 40" ) mic_muted;;
    esac
done
