function how_much_memory() {
	m=$(smem -H -c "name pss" -t -P "$1$" -n -k | tail -n 1 | sed -e 's/^[[:space:]]*//')
    echo "$1 is using ${m}of mem"
}
