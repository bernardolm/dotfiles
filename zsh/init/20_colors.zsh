# avoiding load
return

export COLORS=()

$SHELL_DEBUG && \
    readlink /proc/$$/exe && \
    for color in "${COLORS[@]}"; do
        case $(readlink /proc/$$/exe) in
            *zsh)
                echo -ne "${(P)${color}} The quick brown fox jumps over the lazy dog ${NC}"
                ;;
            *)
                echo -ne "${!color} The quick brown fox jumps over the lazy dog ${NC}"
                ;;
        esac
        echo " --- ${color}"
    done



$SHELL_DEBUG && \
    for clbg in {40..47} {100..107} 49 ; do
        #Foreground
        for clfg in {30..37} {90..97} 39 ; do
            #Formatting
            for attr in 0 1 2 4 5 7 ; do
                #Print the result
                echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
            done
            echo #Newline
        done
    done


$SHELL_DEBUG && \
    for fgbg in 38 48 ; do # Foreground / Background
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

$SHELL_DEBUG && \
    for COLOR in {0..255}
    do
        for STYLE in "38;5"
        do
            TAG="\033[${STYLE};${COLOR}m"
            STR="${STYLE};${COLOR}"
            echo -ne "${TAG}${STR}${NONE}  "
        done
        echo
    done
