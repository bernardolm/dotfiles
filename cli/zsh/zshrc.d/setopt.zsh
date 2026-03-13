export DISABLE_CORRECTION="true"

# The names or labels of the options (setopt) are commonly written in all capitals in the documentation
# but in lowercase when listed with the setopt tool.
# The labels of the options are case insensitive and any underscores in the label are ignored

setopt APPEND_HISTORY # append to history
setopt AUTO_CD # Automatic CD
setopt COMBINING_CHARS
setopt EXTENDED_HISTORY # add a bit more data (timestamp in unix epoch time and elapsed time of the command)
setopt GLOB_COMPLETE # will list possible completions, but not substitute them in the command prompt
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_REDUCE_BLANKS # removes blank lines from history
setopt INC_APPEND_HISTORY # adds commands as they are typed, not at shell exit
setopt NO_CASE_GLOB # Case Insensitive Globbing
setopt SHARE_HISTORY # share history across multiple zsh sessions

unsetopt CORRECT # suggest correction to a possible typo
unsetopt CORRECT_ALL # suggest correction to a possible typo
