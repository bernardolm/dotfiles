vpn() {
	reset

	wezterm cli set-tab-title "🛰️  vpn"

	killall -9 openvpn 2>/dev/null || killall -9 openvpn 2>/dev/null || true

	SCRIPT_DIR=$(cd "$(dirname -- "$0")" && pwd)

	cd ~

	eval sudo /opt/homebrew/opt/openvpn/sbin/openvpn \
		--allow-deprecated-insecure-static-crypto \
		--auth-user-pass ${SCRIPT_DIR}/openvpn.auth \
		--config ${SCRIPT_DIR}/openvpn.ovpn \
		--mute-replay-warnings \
		--pull \
		--verb 3 \
		|| true
}
