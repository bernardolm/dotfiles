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

export CYAN="\e[38;5;235m\e[48;5;45m\e[1m"
export GREEN="\e[38;5;235m\e[48;5;41m\e[1m"
export GREY="\e[38;5;235m\e[48;5;253m\e[1m"
export NC="\e[0m"
export PURPLE="\e[38;5;15m\e[48;5;127m\e[1m"
export RED="\e[38;5;235m\e[48;5;9m\e[1m"
export WHITE="\e[38;5;235m\e[48;5;15m\e[1m"
export YELLOW="\e[38;5;235m\e[48;5;227m\e[1m"
