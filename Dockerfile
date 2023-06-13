FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ENV NO_COLOR=0
ENV TERM=xterm-256color
WORKDIR /opt/dotfiles

RUN apt-get update
RUN apt-get --yes upgrade
RUN apt-get install --yes \
    curl \
    fontconfig \
    gconf2 \
    git \
    gnome-shell-extensions \
    libglib2.0-bin \
    make \
    python3-pip \
    sudo \
    ttf-mscorefonts-installer

ENTRYPOINT [ "make", "setup" ]
