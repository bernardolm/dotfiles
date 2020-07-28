function disable_accelerometter() {
    xinput --list | grep Touchscreen | grep -o 'id=[0-9]\+' | cut -d= -f2 | awk '{print "xinput disable "$1"" | "/bin/sh"}'
}
