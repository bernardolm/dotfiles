# first steps on new ubuntu installation

to install, run:

```bash
reset; [ ! `command -v curl` ] && sudo apt-get update && sudo apt-get install --yes curl ; \
curl -L -o ~/Downloads/dotfiles.zip https://github.com/bernardolm/dotfiles/archive/master.zip ; \
([ -d ~/Downloads/dotfiles ] && rm -rf ~/Downloads/dotfiles) ; \
unzip -oq ~/Downloads/dotfiles.zip -d ~/Downloads/dotfiles ; \
~/Downloads/dotfiles/dotfiles-master/first-steps-ubuntu.sh
```
