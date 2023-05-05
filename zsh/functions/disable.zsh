function disable_accelerometter() {
    xinput &>/dev/null || return 1
    xinput --list | grep Touchscreen | grep -o 'id=[0-9]\+' | cut -d= -f2 | awk '{print "xinput disable "$1"" | "/bin/sh"}'
}

function disable_amazon_search() {
    gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"
}

function disable_tracker() {
	echo -e "\nHidden=true\n" | sudo tee --append /etc/xdg/autostart/tracker-{extract,miner-apps,miner-fs,miner-user-guides,store}.desktop > /dev/null

	gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
	gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false

	tracker reset --hard
}
