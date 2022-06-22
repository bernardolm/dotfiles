function echo_var() {
    local icon="🪧 " # 📜📢🏷️🗞️📥📎🔗🧷🪧
    eval 'printf "%s\n" "$icon $1: ${'"$1"'}"'
}
