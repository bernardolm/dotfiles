.DEFAULT_GOAL := help
.PHONY: help

MAKEFLAGS += --silent
PWD=$(shell pwd)
DOTBOT_CMD="DOTBOT_DIR=./git/modules/dotbot ./install -vv"

default: reset
	@echo "starting docker to test first steps ubuntu"
	@docker build --progress tty -t=dotfiles:test .
	@docker run --rm -it \
		-e DOTFILES=/opt/dotfiles \
		-e SYNC_DOTFILES=/opt/sync \
		-v /var/lib/apt/lists:/var/lib/apt/lists \
		-v ${PWD}:/opt/dotfiles \
		-v ${HOME}/sync:/opt/sync \
		-w /opt/dotfiles \
		dotfiles:test /bin/bash

reset:
	@reset

pre:
	sudo ${PWD}/pre-install

base:
	eval ${DOTBOT_CMD} -c dotbot/base.yaml

apt:
	eval ${DOTBOT_CMD} -c dotbot/apt.yaml \
		-p git/modules/dotbot-sudo/sudo.py \
		--except apt

golang:
	bash ./go/install.sh
	./install -vv \
		-c ${PWD}/dotbot/go.yaml \
		--except go \
		-p ${PWD}/git/modules/dotbot-sudo/sudo.py

pip:
	./install -vv \
		-c ${PWD}/dotbot/pip.yaml \
		-p ${PWD}/git/modules/dotbot-pip/pip.py

snap:
	./install -vv \
		-c ${PWD}/dotbot/snap.yaml \
		-p ${PWD}/git/modules/dotbot-snap/snap.py

post:
	./install -vv \
		-c ${PWD}/dotbot/post.yaml \
		-p ${PWD}/git/modules/dotbot-sudo/sudo.py

setup: reset pre base apt golang pip snap post


# ./git/modules/dotbot/bin/dotbot --base-directory ./git/modules/dotbot --config-file ./dotbot/apt.yaml -p ./git/modules/dotbot-sudo/sudo.py
