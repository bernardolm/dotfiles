function weather() {
    curl wttr.in
}

function weather_by_lat_lon() {
    curl -H 'Accept-Language: pt-br' "wttr.in/$(my_lat_lon)?m2AFnq"
}
