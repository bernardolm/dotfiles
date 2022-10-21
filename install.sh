#!/bin/sh

# Dotfiles are files and folders on Unix-like systems starting with . that control the configuration of applications and shells on your system. You can store and manage your dotfiles in a repository on GitHub. For advice and tutorials about what to include in your dotfiles repository, see GitHub does dotfiles.

# Your dotfiles repository might include your shell aliases and preferences, any tools you want to install, or any other codespace personalization you want to make.

# You can configure Codespaces to use dotfiles from any repository you own by selecting that repository in your personal Codespaces settings.

# When you create a new codespace, GitHub clones your selected repository to the codespace environment, and looks for one of the following files to set up the environment.

# install.sh
# install
# bootstrap.sh
# bootstrap
# script/bootstrap
# setup.sh
# setup
# script/setup
# If none of these files are found, then any files or folders in your selected dotfiles repository starting with . are symlinked to the codespace's ~ or $HOME directory.

# Any changes to your selected dotfiles repository will apply only to each new codespace, and do not affect any existing codespace.

# https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles
# https://dotfiles.github.io/
# https://github.com/holman/dotfiles/blob/master/script/install
# https://github.com/holman/dotfiles/blob/master/script/bootstrap

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

distro='unknown'

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    distro=$ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    distro=$(lsb_release -si)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    distro=$DISTRIB_ID
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    distro=debian
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    echo "wtf are you using?"
    return 1
fi

echo "ok, you are using $distro linux"

case $distro in
debian|ubuntu)
    . debian/install.sh
    ;;
alpine)
    . alpine/install.sh
    ;;
*)
    echo "nothing to do (why are you using $distro linux?)"
    return 0
    ;;
esac



## https://github.com/holman/dotfiles/blob/21342e9f4e7d55ebfdc6e4e9071f94cbbc9eb0ef/script/install
#!/usr/bin/env bash
#
# Run all dotfiles installers.

# set -e

# cd "$(dirname $0)"/..

# # find the installers and run them iteratively
# find . -name install.sh | while read installer ; do sh -c "${installer}" ; done





# BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
