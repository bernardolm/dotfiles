FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ENV NO_COLOR=0
ENV TERM=xterm-256color
WORKDIR /opt/dotfiles

RUN apt update
RUN apt --yes upgrade
RUN apt install --yes \
    curl \
    git \
    make \
    python3-pip \
    sudo \
    ttf-mscorefonts-installer
