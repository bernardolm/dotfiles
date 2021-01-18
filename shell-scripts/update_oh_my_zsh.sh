function update_oh_my_zsh() {
    actual_pwd=$(pwd)

    function update_master_to_latest() {
        echo -e "Updating "$1"...\n"
        cd $1
        git checkout .
        git reflog expire --all --expire=now
        git gc --prune=now --aggressive
        git checkout master
        git pull origin master

        echo -e '\n---\n'
    }

    upgrade_oh_my_zsh
    echo -e '\n---\n'
    update_master_to_latest $ZSH/custom/plugins/alias-tips
    update_master_to_latest $ZSH/custom/plugins/kubetail
    update_master_to_latest $ZSH/custom/plugins/zsh-completions
    update_master_to_latest $ZSH/custom/plugins/zsh-syntax-highlighting
    update_master_to_latest $ZSH/custom/plugins/zsh-wakatime
    update_master_to_latest $ZSH/custom/themes/spaceship-prompt

    cd ${actual_pwd}
}
