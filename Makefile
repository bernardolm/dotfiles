.DEFAULT_GOAL := help
.PHONY: help

MAKEFLAGS += --silent
PWD=$(shell pwd)
DOTBOT_CMD="./install"

test: reset
	echo "building docker image to test first steps ubuntu"
	docker build \
		--build-arg="UIDH=$(shell id -u)" \
		--build-arg="USER=${USER}" \
		--build-arg="GIDH=$(shell grep ${USER} /etc/passwd | cut -d: -f4)" \
		--progress=plain \
		-t=${GITHUB_USER}/dotfiles:test \
		.
	echo "starting docker container"
	docker run --rm -it \
		--user ${USER} \
		-e DOTFILES=/home/${USER}/dotfiles \
		-e SYNC_DOTFILES=/home/${USER}/sync \
		-e USER=${USER} \
		-v /etc/apt/sources.list:/etc/apt/sources.list:ro \
		-v ${HOME}/sync:/home/${USER}/sync:ro \
		-v ${PWD}:/home/${USER}/dotfiles:ro \
		-v ${PWD}/.git:/home/${USER}/dotfiles/.git \
		-v ${PWD}/git/modules:/home/${USER}/dotfiles/git/modules \
		-w /home/${USER}/dotfiles \
		${GITHUB_USER}/dotfiles:test

reset:
	reset

pre:
	sudo ${PWD}/pre-setup

# golang:
# 	eval ${DOTBOT_CMD} -c dotbot/go.yaml \
# 		--except go

# pip:
# 	eval ${DOTBOT_CMD} -c dotbot/pip.yaml \
# 		-p git/modules/dotbot-pip/pip.py

# snap:
# 	eval ${DOTBOT_CMD} -c dotbot/snap.yaml \
# 		-p git/modules/dotbot-snap/snap.py

# post:
# 	eval ${DOTBOT_CMD} -c dotbot/post.yaml \
# 		-p git/modules/dotbot-sudo/sudo.py

# setup: reset pre base apt pip snap golang post
