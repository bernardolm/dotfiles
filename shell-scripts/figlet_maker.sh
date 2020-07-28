function figlet_maker () {
    figlet $1 | sed -e s/$/\ \\\\n\"/g | sed -e s/\^/\@printf\ \"\\\\033\[33m/g | sed -e s/\`/\\\\\`/g
    echo @printf '"\\033[0m\\n"'
}
