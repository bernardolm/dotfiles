vpn() {
	wezterm cli set-tab-title "🛰️  vpn"

	killall -9 openvpn 2>/dev/null || true

	vpn_config_dir=$HOME/sync/personal/vpn/acao/

	cd ~

	sudo /opt/homebrew/opt/openvpn/sbin/openvpn \
		--allow-deprecated-insecure-static-crypto \
		--auth-user-pass $vpn_config_dir/openvpn.auth \
		--config $vpn_config_dir/openvpn.ovpn \
		--mute-replay-warnings \
		--pull \
		--verb 1 \
		|| true
}
