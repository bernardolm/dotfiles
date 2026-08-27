# Moved out of ~/.zshenv: this needs to run after zimfw's completion module
# (so `compdef` already exists and gcloud's own compinit guard skips it).
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
	. "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
