FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y sudo wget

ENV TERM xterm-256color
ENV MYUSER runner

ADD entrypoint.sh .

RUN addgroup $MYUSER && \
    useradd -g $MYUSER $MYUSER && \
    usermod -G sudo $MYUSER && \
    echo "$MYUSER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $MYUSER

ENTRYPOINT [ "./entrypoint.sh"]
