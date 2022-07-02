function is_number() {
    local num=$1
    local rg="^[+\-]{0,1}[0-9]+$"
    (echo "${num//[^\-+0-9]/}" | grep -Eq $rg) \
        && echo 1 \
        || echo 0
}
