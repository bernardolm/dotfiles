function reset_audio() {
    sudo killall pulseaudio
    /bin/rm -rf ~/.config/pulse/*
    /bin/rm -rf ~/.pulse*
    pulseaudio --dump-conf --dump-modules --dump-resample-methods --cleanup-shm --start -D
}
