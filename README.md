# first-steps-ubuntu

to install, run:

```bash
reset; [ ! `command -v curl` ] && sudo apt update && sudo apt install --yes curl ; \
curl -L -o ~/Downloads/first-steps-ubuntu.zip https://github.com/bernardolm/first-steps-ubuntu/archive/master.zip ; \
unzip -oq ~/Downloads/first-steps-ubuntu.zip -d ~/Downloads/first-steps-ubuntu ; \
~/Downloads/first-steps-ubuntu/first-steps-ubuntu-master/first-steps-ubuntu.sh
```
