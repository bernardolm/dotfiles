function progress_bar() {
    CURRENT=$1
    TARGET=$2
    ((POSITION=100*$CURRENT/$TARGET))
    LR='\033[1;31m'
    LC='\033[1;36m'
    LW='\033[1;37m'
    NC='\033[0m'
    TEXT="$CURRENT/$TARGET"
    PRC=$(printf "%.0f" ${POSITION})
    SHW=$(printf "%3d\n" ${PRC})
    LNE=$(printf "%.0f" $((${PRC} / 2)))
    LRR=$(printf "%.0f" $((${PRC} / 2 - 12)))
    LCC=$(printf "%.0f" $((${PRC} / 2 - 50)))
    if [ ${LCC} -le 0 ]; then LCC=0; fi
    LCC_=""
    for ((i = 1; i <= 50; i++)); do
        DOTS=""
        for ((ii = ${i}; ii < 50; ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}🔷"; else LCC_="${LCC_}🔸"; fi
        echo -ne "> ${LW}${TEXT} ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS} ${SHW}%${NC}\r"
        if [ ${LNE} -ge 26 ]; then sleep .05; fi
    done
}
