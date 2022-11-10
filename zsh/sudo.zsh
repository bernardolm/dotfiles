sudo() {
	# shellcheck disable=SC2312
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	else
		if ! command sudo --non-interactive true 2>/dev/null; then
			_warn "root privileges are required, please enter your password below. pay attention for what you doing!"
			command sudo --validate
		fi
		command sudo "$@"
	fi
}
