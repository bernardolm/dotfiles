FROM ubuntu:jammy

ARG GIDH=999
ARG UIDH=999
ARG USER=bot
ENV TERM=xterm-256color
WORKDIR /opt/dotfiles

RUN apt-get update && \
    apt-get install --no-install-recommends --yes  \
    sudo locales apt-utils dialog

# to turn tests fast
RUN apt-get upgrade --no-install-recommends --yes
RUN apt-get install --no-install-recommends --yes \
    git
# to turn tests fast

RUN groupadd -g ${GIDH} ${USER} && \
    useradd --create-home -u ${UIDH} -g ${GIDH} ${USER} && \
    usermod -a -G sudo,${USER} ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT [ "./install-pristine" ]
