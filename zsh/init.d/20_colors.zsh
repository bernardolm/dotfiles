# shell_debug_relay=$SHELL_DEBUG
# SHELL_DEBUG=false

$SHELL_DEBUG && \
    # for fgbg in 38 48 ; do # Foreground / Background
    for fgbg in 48 ; do # Foreground / Background
        for color in {0..255} ; do # Colors
            # Display the color
            printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
            # Display 6 colors per lines
            if [ $((($color + 1) % 6)) == 4 ] ; then
                echo # New line
            fi
        done
        echo # New line
    done

# SHELL_DEBUG=$shell_debug_relay

export CLR_BLUE="\e[38;5;15m\e[48;5;21m\e[1m"
export CLR_CYAN="\e[38;5;235m\e[48;5;51m\e[1m"
export CLR_GREEN="\e[38;5;235m\e[48;5;40m\e[1m"
export CLR_GREY="\e[38;5;235m\e[48;5;253m\e[1m"
export NO_COLOR="\e[0m"
export CLR_PURPLE="\e[38;5;15m\e[48;5;129m\e[1m"
export CLR_RED="\e[38;5;235m\e[48;5;9m\e[1m"
export CLR_ROSE="\e[38;5;15m\e[48;5;201m\e[1m"
export CLR_WHITE="\e[38;5;235m\e[48;5;5m\e[1m"
export CLR_YELLOW="\e[38;5;235m\e[48;5;226m\e[1m"
