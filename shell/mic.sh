function mic_on() {
    pacmd set-source-mute 2 0
    mic_state
}

function mic_muted() {
    pacmd set-source-mute 2 1
    mic_state
}

function mic_state() {
    state=`pacmd list-sources | grep -e 'index' -e 'muted:' | sed -n -e '/index: 2/,$p' | head -n2 | tail -n1 | grep yes &>/dev/null && echo muted || echo on`
    icon='audio-input-microphone-symbolic'
    if [[ "$state" == "muted" ]]; then icon='audio-input-microphone-muted-symbolic'; fi
    # notify-send --hint=int:transient:1 -i $icon "mic is $state"
    echo "mic is $state"
}
