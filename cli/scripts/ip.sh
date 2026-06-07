#!/usr/bin/env /bin/sh

set -e
set -x
set -v

filepath="$HOME/sync/ip_log.txt"
[ ! -f "$filepath" ] && touch "$filepath"

ip_public=$(curl -s ifconfig.me)
ip_local=$(hostname -I 2>/dev/null || \
	ipconfig getifaddr en1 || \
	ipconfig getifaddr en0)

now=$(date +"%Y-%m-%d %H:%M:%S")
host=$(hostname -s)

printf \
	'%s\n' '0i' "$now	$ip_local	$ip_public	$host" \
	'.' 'w' 'q' | \
	ed -s $filepath

head -n5 $filepath
