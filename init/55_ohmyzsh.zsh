plugins=""

cat $DOTFILES/zinit/ohmyzsh.txt | grep -v '#' | while read -r file ; do
    plugins+=$(cut -d':' -f3 <<<$file)","
done

plugins=(${(@s:,:)plugins})

source $ZSH/oh-my-zsh.sh
