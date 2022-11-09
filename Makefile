
default:
	@echo "starting docker to test first steps ubuntu"
	@docker build -t=bernardolm/dotfiles .
	@docker run --rm -v `pwd`:/opt/dotfiles --workdir=/opt/dotfiles bernardolm/dotfiles ./ubuntu/install.sh

reset:
	@reset

base:
	-./install -c ./dotbot-config/base.yaml

apt:
	-sudo ./install -c ./dotbot-config/aptget.yaml \
		-p ./dotbot_plugin_aptget/aptget.py

go:
	-./install -c ./dotbot-config/go.yaml \
		-p ./dotbot-golang/go.py

pip:
	-./install -c ./dotbot-config/pip.yaml \
		-p ./dotbot-pip/pip.py

snap:
	-./install -c ./dotbot-config/snap.yaml \
		-p ./dotbot-snap/snap.py

setup: reset base apt go pip snap
