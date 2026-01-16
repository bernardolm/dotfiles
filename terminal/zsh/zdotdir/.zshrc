echo "~/.zshrc"

# setopt ERR_EXIT
# set -e

echo "ZIM_HOME: $ZIM_HOME"

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

ssh-agent -s > "$HOME/.ssh/ssh-agent"
eval "$(cat "$HOME/.ssh/ssh-agent")"
ssh-add
ssh-add -l
ssh-add -L

# export GIT_TRACE=1
# export GIT_CURL_VERBOSE=1

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Initialize modules.
# source ${ZIM_HOME}/init.zsh



# exit 1

# # Set up the prompt

# autoload -Uz promptinit
# promptinit
# prompt adam2



# # Use emacs keybindings even if our EDITOR is set to vi
# bindkey -e



# Use modern completion system
autoload -Uz compinit
compinit


eval "$(dircolors -b)"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true


alias ls='exa'

alias ll='ls -lh'
alias la='ls -lah'
alias code='$HOME/bin/code serve-web --accept-server-license-terms --port 8000'


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000

if [ -f $HOME/.zsh_history ]; then
	cat $HOME/.zsh_history >> $HOME/sync/linux/home/.zsh_history
	rm -f $HOME/.zsh_history
fi
if [ -f $ZDOTDIR/.zsh_history ]; then
	cat $ZDOTDIR/.zsh_history >> $HOME/sync/linux/home/.zsh_history
	rm -f $ZDOTDIR/.zsh_history
fi
HISTFILE=$HOME/sync/linux/home/.zsh_history



source $HOME/workspaces/misc/ohmyzsh/plugins/git/git.plugin.zsh


# # # Source - https://superuser.com/a/1840396
# # # Posted by Silas, modified by community. See post 'Timeline' for change history
# # # Retrieved 2026-01-08, License - CC BY-SA 4.0
# # su $USER -ls /bin/zsh -c 'setopt; echo -e $startup_trace; exit'



# Starship prompt.
if ! command -v starship >/dev/null 2>&1; then
	curl -sS https://starship.rs/install.sh | sh
fi
eval "$(starship init zsh)"

# # Load optional local overrides.
# if [[ -d "${DOTFILES}/terminal/zsh/zshrc.d" ]]; then
#   for file in ${DOTFILES}/terminal/zsh/zshrc.d/*.zsh; do
#     [[ -r "$file" ]] && source "$file"
#   done
# fi

# # # Different Prompt for ssh
# # if [[ -z "$SSH_CLIENT" ]]; then
# # 	# local connection, change prompt
# # # 	export PS1="\[\e[1;30m\]\W\[\e[m\] \\$ "
# # # else
# # 	# ssh connection, print hostname and os version
# # 	echo "Welcome to $(scutil --get ComputerName) ($(sw_vers -productVersion))"
# # fi

# alias -g la='ls -lah'
# alias -g ll='ls -l'

# # For example, you can a suffix alias for the txt file extension:
# # alias -s txt="open -t"
# # alias -s tf="tail -f"

autoload bashcompinit && bashcompinit # load bashcompinit for some old bash completions
autoload -Uz compinit && compinit # load default completions

# # HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# HISTSIZE=2000
# SAVEHIST=5000



# The names or labels of the options (setopt) are commonly written in all capitals in the documentation
# but in lowercase when listed with the setopt tool.
# The labels of the options are case insensitive and any underscores in the label are ignored
setopt APPEND_HISTORY # append to history
setopt AUTO_CD # Automatic CD
setopt CORRECT # suggest correction to a possible typo
setopt CORRECT_ALL # suggest correction to a possible typo
setopt EXTENDED_HISTORY # add a bit more data (timestamp in unix epoch time and elapsed time of the command)
setopt GLOB_COMPLETE # will list possible completions, but not substitute them in the command prompt
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching
setopt HIST_IGNORE_DUPS # do not store duplications
setopt HIST_REDUCE_BLANKS # removes blank lines from history
setopt INC_APPEND_HISTORY # adds commands as they are typed, not at shell exit
setopt NO_CASE_GLOB # Case Insensitive Globbing
setopt SHARE_HISTORY # share history across multiple zsh sessions



# git
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git




# # # Add a spacer to a dock to separate pinned and opened apps
# # defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# # # Make Dock icons of hidden applications translucent
# # defaults write com.apple.dock showhidden -bool true
# # killall Dock

# # # Show file extensions
# # defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# # # Show hiddne files
# # defaults write com.apple.finder AppleShowAllFiles -bool true
# # # Show full POSIX path in the title
# # defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# # # Path bar in the bottom
# # defaults write com.apple.finder ShowPathbar -bool true
# # # Keep the folder first when sorting
# # defaults write com.apple.finder _FXSortFoldersFirst -bool true
# # # Use list view in all Finder windows by default: Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
# # defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# # killall Finder


# # # Set the screenshot location
# # defaults write com.apple.screencapture location -string "${HOME}/Downloads"
# # # Set the screenshot format to be jpeg
# # defaults write com.apple.screencapture type -string "jpg"
# # killall ScreenCapture








# # brew "bat"
# # brew "chafa"
# # brew "exiftool"
# # brew "fastfetch"
# # brew "fd"
# # brew "ffmpeg"
# # brew "figlet"
# # brew "git-filter-repo"
# # brew "hugo"
# # brew "imagemagick"
# # brew "poppler"
# # brew "ripgrep"
# # brew "tree"
# # brew "fish"
# # brew "fzf"
# # brew "htop"
# # brew "lf"
# # brew "lua"
# # brew "neovim"
# # brew "node"
# # brew "rust"
# # brew "stow"
# # brew "tmux"
# # brew "wget"

# # cask "macvim-app"
# # cask "wezterm"

# # cask "itsycal"

# # cask "jordanbaird-ice"
# # cask "maccy"
# # cask "stats"

# # cask "bitwarden"
# # cask "skim"

# # cask "firefox"
# # cask "docker-desktop"
# # cask "intellij-idea"
# # cask "kitty"
# # cask "mactex-no-gui"
# # cask "neovide-app"
# # cask "rstudio"
# # cask "utm"

# # cask "discord"
# # cask "minecraft"
# # cask "spotify"

# # cask "notion"

# # cask "cryptomator"
# # cask "filen"
# # cask "nextcloud"
# # cask "syncthing-app"

# # cask "cemu"
# # cask "gimp"
# # cask "keycastr"
# # cask "obs"
# # cask "vlc"

# # cask "tailscale-app"
# # cask "thunderbird"
# # cask "ungoogled-chromium"

# # brew bundle --file ${DOT_DIR}/homebrew/Brewfile_optional

# cd $HOME
