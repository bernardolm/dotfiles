function apt_search_installed() {
    apt list --installed "*$1*" 2>/dev/null | awk -F'/' 'NR>1{print $1}'
}

function apt_get_keys() {
    sudo apt update | sed -nr 's/^.*NO_PUBKEY\s(\w{16}).*$/\1/p' | xargs -I{} -x bash -c 'sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys {} 1>/dev/null &'
    curl -s https://packagecloud.io/install/repositories/eugeny/tabby/script.deb.sh | sudo bash
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E # dropbox
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
}
