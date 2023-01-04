
default:
	@echo "starting docker to test first steps ubuntu"
	@docker build -t=bernardolm/dotfiles .
	@docker run --rm -v `pwd`:/opt/dotfiles --workdir=/opt/dotfiles bernardolm/dotfiles ./ubuntu/install.sh

reset:
	@reset

sudo:
	-sudo ./install -c ./dotbot-config/sudo.yaml

base:
	-./install -c ./dotbot-config/base.yaml

apt:
	-sudo ./install -c ./dotbot-config/apt.yaml \
		-p ./dotbot_plugin_aptget/aptget.py

go:
	-./install -c ./dotbot-config/go.yaml \
		-p ./dotbot-golang/go.py

pip:
	-./install -c ./dotbot-config/pip.yaml \
		-p ./dotbot-python/pip.py

snap:
	-./install -c ./dotbot-config/snap.yaml \
		-p ./dotbot-snap/snap.py

setup: reset sudo base apt go pip snap
