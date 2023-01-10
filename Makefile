default:
	@echo "starting docker to test first steps ubuntu"
	@docker build -t=bernardolm/dotfiles .
	@docker run --rm -v `pwd`:/opt/dotfiles --workdir=/opt/dotfiles bernardolm/dotfiles ./ubuntu/install.sh

reset:
	@reset

pre:
	-@sudo ./pre-install

base:
	-@./install -vv -c ./dotbot-config/base.yaml

apt:
	-@./install -vv -c ./dotbot-config/apt.yaml \
		--except apt \
		-p ./dotbot-sudo/sudo.py

golang:
	-@bash go/install.sh
	-@./install -vv -c ./dotbot-config/go.yaml \
		--except go \
		-p ./dotbot-sudo/sudo.py

pip:
	-@./install -vv -c ./dotbot-config/pip.yaml \
		-p ./dotbot-pip/pip.py

snap:
	-@./install -vv -c ./dotbot-config/snap.yaml \
		-p ./dotbot-snap/snap.py

post:
	-@./install -vv -c ./dotbot-config/post.yaml \
		-p ./dotbot-sudo/sudo.py

setup: reset pre base apt golang pip snap post
