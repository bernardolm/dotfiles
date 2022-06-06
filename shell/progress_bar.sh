function progress_bar() {
    local bar=""
    local current=$1
    local left_char="█"
    local right_char="░"
    local bar_size=999999
    local target=$2
    local terminal_size=$(tput cols)

    local target_char_size=$(expr length $target)
    local left_message="▁ $(eval printf %${target_char_size}s $current)/$target "
    
    ((position=100*$current/$target))
    local right_message=" $(printf %3s $position)% "

    local messages_size=$(expr length "${left_message}${right_message}")
    ((total_size=$messages_size+$bar_size))

    if [ $total_size -gt $terminal_size ]; then
        ((bar_size=$terminal_size-$messages_size));
    fi

    for ((left=0; left<$position; left++)); do bar+=$left_char; done
    for ((right=$position; right<$bar_size; right++)); do bar+=$right_char; done
    echo -ne "$left_message$bar$right_message\r"
}
