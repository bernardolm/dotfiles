FROM ubuntu:jammy

ARG GIDH=999
ARG UIDH=999
ARG USER=bot
ENV TERM=xterm-256color
WORKDIR /opt/dotfiles

RUN apt-get update && \
    apt-get --no-install-recommends --yes install \
    sudo locales apt-utils dialog

# to turn tests fast
RUN apt-get --yes upgrade
RUN apt-get --no-install-recommends --yes install \
    git
# to turn tests fast

RUN groupadd -g ${GIDH} ${USER} && \
    useradd --create-home -u ${UIDH} -g ${GIDH} ${USER} && \
    usermod -a -G sudo,${USER} ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT [ "./install-pristine" ]
