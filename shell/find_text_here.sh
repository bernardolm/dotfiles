function find_text_here() {
    grep -irnwEe $1 .
}
