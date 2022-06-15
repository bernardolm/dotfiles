function spaceship_history_size() {
    backup_it $SYNC_PATH/.zsh_history
    echo -n "💽 `wc -l < $SYNC_PATH/.zsh_history` "
}

export SPACESHIP_PROMPT_ORDER=(
    time              # Time stamps section
    history_size
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
    # conda             # conda virtualenv section
    kubectl           # Kubectl context section
    # line_sep        # Line break
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
export SPACESHIP_JOBS_SHOW=true
export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
export SPACESHIP_RANDOM_EMOJI_SHOW=true
export SPACESHIP_TIME_12HR=false
export SPACESHIP_TIME_PREFIX="⌚ "
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_USER_SHOW=needed
export SPACESHIP_VENV_SYMBOL="🤖🐍 "

LS_COLORS=$LS_COLORS:'ow=01;34:' ; export LS_COLORS

zinit light spaceship-prompt/spaceship-prompt

# autoload -Uz $fpath[1]/*(.:t)

autoload -Uz promptinit
# promptinit
# prompt spaceship
