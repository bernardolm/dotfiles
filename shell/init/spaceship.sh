function spaceship_histsize() {
    # If SPACESHIP_HISTSIZE_SHOW is false, don't show histsize section
    [[ $SPACESHIP_HISTSIZE_SHOW == false ]] && return

    # Use quotes around unassigned local variables to prevent
    # getting replaced by global aliases
    # http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliasing
    local 'histfile_size'

    histfile_size=$([ -f $HISTFILE ] && echo -n $(wc -l <$HISTFILE))

    # Exit section if variable is empty
    [[ -z $histfile_size ]] && return

    export SPACESHIP_HISTSIZE_COLOR=${SPACESHIP_HISTSIZE_COLOR="white"}
    export SPACESHIP_HISTSIZE_SYMBOL=${SPACESHIP_HISTSIZE_SYMBOL=📜}

    # Display histsize section
    spaceship::section \
        "$SPACESHIP_HISTSIZE_COLOR" \
        "$SPACESHIP_HISTSIZE_PREFIX" \
        "${SPACESHIP_HISTSIZE_SYMBOL} ${histfile_size} " \
        "$SPACESHIP_HISTSIZE_SUFFIX"
}

export SPACESHIP_PROMPT_ORDER=(
    time           # Time stamps section
    histsize       # ZSH command history counter
    dir            # Current directory section
    host           # Hostname section
    git            # Git section (git_branch + git_status)
    package        # Package version
    node           # Node.js section
    ruby           # Ruby section
    golang         # Go section
    php            # PHP section
    docker_context # Docker context
    aws            # Amazon Web Services section
    gcloud         # Google Cloud Platform section
    venv           # virtualenv section
    kubectl        # Kubectl context section
    battery        # Battery level and status
    jobs           # Background jobs indicator
    exit_code      # Exit code section
    exec_time      # Execution time
    random_emoji   # Random emoji to better distinct terminals
    char           # Prompt character
)

export LS_COLORS=$LS_COLORS:'ow=01;34:'
export SPACESHIP_BATTERY_SHOW=true
export SPACESHIP_BATTERY_SYMBOL_FULL=""
export SPACESHIP_BATTERY_THRESHOLD=25
export SPACESHIP_CHAR_SYMBOL_ROOT="🚨 "
export SPACESHIP_DIR_PREFIX='📂 in '
# export SPACESHIP_DIR_TRUNC=3
export SPACESHIP_DOCKER_SHOW=true
export SPACESHIP_EXEC_TIME_ELAPSED=0.1
export SPACESHIP_EXEC_TIME_PREFIX="⏳ "
export SPACESHIP_EXIT_CODE_COLOR="white"
export SPACESHIP_EXIT_CODE_SHOW=true
export SPACESHIP_EXIT_CODE_SYMBOL="🚧 "
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_GIT_BRANCH_SUFFIX=""
export SPACESHIP_GIT_PREFIX='📇 git:('$SPACESHIP_CHAR_SYMBOL
export SPACESHIP_GIT_SUFFIX=") "
export SPACESHIP_HISTSIZE_SHOW=true
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

zinit light spaceship-prompt/spaceship-prompt

autoload -Uz promptinit
promptinit
