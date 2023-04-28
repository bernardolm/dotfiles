return

export COLORS=()

$DEBUG_SHELL && \
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
