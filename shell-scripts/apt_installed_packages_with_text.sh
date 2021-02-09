function apt_installed_packages_with_text() {
    apt-get list --installed "*$1*" 2>/dev/null | awk -F'/' 'NR>1{print $1}'
}
