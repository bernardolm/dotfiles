export LS_COLORS=$LS_COLORS:'ow=01;34:'

export SPACESHIP_PROMPT_ORDER=(
    time          # Time stampts section
    histsize      # ZSH command history counter
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    # hg            # Mercurial section (hg_branch  + hg_status)
    package       # Package version
    node          # Node.js section
    ruby          # Ruby section
    python        # Python section
    # elm           # Elm section
    # elixir        # Elixir section
    # xcode         # Xcode section
    # swift         # Swift section
    golang        # Go section
    php           # PHP section
    rust          # Rust section
    # haskell       # Haskell Stack section
    # java          # Java section
    # julia         # Julia section
    docker        # Docker section
    aws           # Amazon Web Services section
    gcloud        # Google Cloud Platform section
    venv          # virtualenv section
    # conda         # conda virtualenv section
    # dotnet        # .NET section
    kubectl       # Kubectl context section
    # terraform     # Terraform workspace section
    # ibmcloud      # IBM Cloud section
    exec_time     # Execution time
    # # async         # Async jobs indicator
    # # line_sep      # Line break
    battery       # Battery level and status
    # jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
    random_emoji  # Random emoji to better distinct terminals
)


# export SPACESHIP_BATTERY_SYMBOL_FULL=""
# export SPACESHIP_CHAR_SYMBOL_ROOT="☣🚨 "
# export SPACESHIP_DIR_TRUNC=3
# export SPACESHIP_DOCKER_SHOW=true
# export SPACESHIP_EXEC_TIME_ELAPSED=0.1
# export SPACESHIP_EXEC_TIME_PREFIX="⏳ "
# export SPACESHIP_EXIT_CODE_COLOR="white"
# export SPACESHIP_EXIT_CODE_SHOW=true
# export SPACESHIP_EXIT_CODE_SYMBOL="🚧 "
# export SPACESHIP_GCLOUD_SHOW=false
# export SPACESHIP_GIT_BRANCH_SUFFIX=""
# export SPACESHIP_GIT_PREFIX='📇 git:('$SPACESHIP_CHAR_SYMBOL
# export SPACESHIP_GIT_SUFFIX=") "
# export SPACESHIP_HISTSIZE_SHOW=true
# export SPACESHIP_JOBS_SHOW=true
# export SPACESHIP_PROMPT_ADD_NEWLINE=false
# export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
# export SPACESHIP_RANDOM_EMOJI_SHOW=true
# export SPACESHIP_TIME_12HR=false
# export SPACESHIP_USER_SHOW=needed
# export SPACESHIP_VENV_SYMBOL="🤖🐍 "

export SPACESHIP_ASYNC_SHOW_COUNT=true
export SPACESHIP_ASYNC_SUFFIX=" "
export SPACESHIP_ASYNC_SYMBOL="⚡ "
export SPACESHIP_BATTERY_THRESHOLD=25
export SPACESHIP_DIR_PREFIX='in 📂 '
export SPACESHIP_EXEC_TIME_PRECISION=4
export SPACESHIP_EXEC_TIME_THRESHOLD=0
export SPACESHIP_PROMPT_ASYNC=false
export SPACESHIP_PROMPT_DEFAULT_SUFFIX=" "
export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
export SPACESHIP_TIME_PREFIX="⌚ "
export SPACESHIP_TIME_SHOW=true

source $DOTFILES/zsh/spaceship_histsize.zsh
source $DOTFILES/zsh/spaceship_random_emoji.zsh

zinit load spaceship-prompt/spaceship-prompt
