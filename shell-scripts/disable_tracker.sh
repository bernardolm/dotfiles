function disable_tracker() {
	echo -e "\nHidden=true\n" | sudo tee --append /etc/xdg/autostart/tracker-{extract,miner-apps,miner-fs,miner-user-guides,store}.desktop > /dev/null

	gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
	gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false

	tracker reset --hard
}
