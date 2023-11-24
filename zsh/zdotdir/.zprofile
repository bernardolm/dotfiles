$SHELL_DEBUG && echo "👾 zprofile"

#
# Ref.: https://github.com/Eugeny/tabby/wiki/Shell-working-directory-reporting
#
precmd () { echo -n "\x1b]1337;CurrentDir=$(pwd)\x07" }
