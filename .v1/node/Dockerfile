FROM node:alpine

ARG UID
ENV USER=nodejs

RUN addgroup -S -g $UID $USER && \
    mkdir -p /home/$USER/app && \
    adduser -S -u $UID -D -H \
    -h /home/$USER \
    -G $USER \
    -g $USER $USER && \
    chown -R $USER:$USER /home/$USER && \
    chmod -R ugo+rwX /home/$USER

RUN npm --loglevel=verbose install -g \
    npm@11.5.2 \
    @google/gemini-cli \
    tldr

WORKDIR /home/$USER/app

USER $USER
