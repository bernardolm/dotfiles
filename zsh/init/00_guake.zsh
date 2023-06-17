if [[ $(ps -eo comm | grep -c guake) -gt 0 ]]; then
    notify-send "Guake" "Loading personal preferences..."
    dconf reset -f /apps/guake/
    dconf load /apps/guake/ < "${DOTFILES}/guake/config.dconf"
fi
