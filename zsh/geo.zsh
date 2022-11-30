function my_lat_lon() {
    curl -s ipinfo.io | jq -rM '.loc'
}
