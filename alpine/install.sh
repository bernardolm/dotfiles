#!/bin/sh
echo "welcome to alpine install"

repositories="
http://dl-cdn.alpinelinux.org/alpine/v3.15/main
http://dl-cdn.alpinelinux.org/alpine/v3.15/community
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
"

echo "$repositories" | tee -a /etc/apk/repositories

apk update

apk add \
    attr \
    bash \
    bash-completion \
    binutils \
    busybox-extras \
    cfdisk \
    chsh \
    curl \
    dialog \
    docs \
    dosfstools \
    e2fsprogs \
    findutils \
    fzf \
    gawk \
    git \
    grep \
    haveged \
    htop \
    iputils \
    less \
    libuser \
    lsof \
    make \
    man-pages \
    mandoc \
    nano \
    openrc \
    openrc-doc \
    pciutils \
    py3-pip \
    py3-virtualenv \
    python3 \
    readline \
    rsync \
    sed \
    sudo \
    syncthing \
    usbutils \
    util-linux \
    zsh \
    && echo "done"
