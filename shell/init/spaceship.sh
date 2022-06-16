function spaceship_histsize() {
    # [ -f $HISTSIZE ] && echo -n "💽 `wc -l < $HISTSIZE` "
    [ -f $HISTSIZE ] && echo -n `wc -l < $HISTSIZE`
}

export SPACESHIP_PROMPT_ORDER=(
    time              # Time stamps section
    histsize
    dir               # Current directory section
    host              # Hostname section
    git               # Git section (git_branch + git_status)
    package           # Package version
    node              # Node.js section
    ruby              # Ruby section
    golang            # Go section
    php               # PHP section
    docker            # Docker section
    docker_context    # Docker context
    aws               # Amazon Web Services section
    gcloud            # Google Cloud Platform section
    venv              # virtualenv section
    kubectl           # Kubectl context section
    battery           # Battery level and status
    jobs              # Background jobs indicator
    random_emoji      # Random emoji to better distinct terminals
    exit_code         # Exit code section
    exec_time         # Execution time
    char              # Prompt character
)

export SPACESHIP_BATTERY_SHOW=true
export SPACESHIP_BATTERY_SYMBOL_FULL=""
export SPACESHIP_BATTERY_THRESHOLD=25
export SPACESHIP_CHAR_SYMBOL_ROOT="🚨 "
export SPACESHIP_DIR_TRUNC=2
export SPACESHIP_DOCKER_SHOW=true
export SPACESHIP_EXEC_TIME_ELAPSED=0.1
export SPACESHIP_EXEC_TIME_PREFIX="⏱ "
export SPACESHIP_EXIT_CODE_COLOR="white"
export SPACESHIP_EXIT_CODE_SHOW=true
export SPACESHIP_EXIT_CODE_SYMBOL="🚧 "
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_HISTSIZE_PREFIX_SHOW=true
export SPACESHIP_HISTSIZE_PREFIX="💽 "
export SPACESHIP_JOBS_SHOW=true
export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
export SPACESHIP_RANDOM_EMOJI_SHOW=true
export SPACESHIP_TIME_12HR=false
export SPACESHIP_TIME_PREFIX="⌚ "
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_USER_SHOW=needed
export SPACESHIP_VENV_SYMBOL="🤖🐍 "

###############################################################################

# USER
SPACESHIP_USER_PREFIX="" # remove `with` before username
SPACESHIP_USER_SUFFIX="" # remove space before host

# HOST
# Result will look like this:
#   username@:(hostname)
SPACESHIP_HOST_PREFIX="@:("
SPACESHIP_HOST_SUFFIX=") "

# DIR
SPACESHIP_DIR_PREFIX='' # disable directory prefix, cause it's not the first section
SPACESHIP_DIR_TRUNC='1' # show only last directory

# GIT
# Disable git symbol
SPACESHIP_GIT_SYMBOL="" # disable git prefix
SPACESHIP_GIT_BRANCH_PREFIX="" # disable branch prefix too
# Wrap git in `git:(...)`
SPACESHIP_GIT_PREFIX='git:('
SPACESHIP_GIT_SUFFIX=") "
SPACESHIP_GIT_BRANCH_SUFFIX="" # remove space after branch name
# Unwrap git status from `[...]`
SPACESHIP_GIT_STATUS_PREFIX=""
SPACESHIP_GIT_STATUS_SUFFIX=""

# NODE
SPACESHIP_NODE_PREFIX="node:("
SPACESHIP_NODE_SUFFIX=") "
SPACESHIP_NODE_SYMBOL=""

# RUBY
SPACESHIP_RUBY_PREFIX="ruby:("
SPACESHIP_RUBY_SUFFIX=") "
SPACESHIP_RUBY_SYMBOL=""

# GOLANG
SPACESHIP_GOLANG_PREFIX="go:("
SPACESHIP_GOLANG_SUFFIX=") "
SPACESHIP_GOLANG_SYMBOL=""

# # DOCKER
# SPACESHIP_DOCKER_PREFIX="docker:("
# SPACESHIP_DOCKER_SUFFIX=") "
# SPACESHIP_DOCKER_SYMBOL=""

# VENV
SPACESHIP_VENV_PREFIX="venv:("
SPACESHIP_VENV_SUFFIX=") "

# PYENV
SPACESHIP_PYENV_PREFIX="python:("
SPACESHIP_PYENV_SUFFIX=") "
SPACESHIP_PYENV_SYMBOL=""

###############################################################################

LS_COLORS=$LS_COLORS:'ow=01;34:' ; export LS_COLORS

zinit light spaceship-prompt/spaceship-prompt

autoload -Uz promptinit
promptinit
