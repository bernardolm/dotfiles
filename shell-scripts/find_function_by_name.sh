function find_function_by_name() {
    echo "searching functions or aliases with term: $1"
    print -rl -- ${(k)aliases} ${(k)functions} ${(k)parameters} | grep $1
}
