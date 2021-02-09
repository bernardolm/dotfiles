FROM php:7-cli

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /home/workdir

RUN apt-get update && apt-get install --yes --no-install-recommends \
    apt-utils \
    dialog \
    git \
    iproute2 \
    less \
    lsb-release \
    openssh-client \
    procps \
    zip \
    unzip \
    && apt-get --purge autoremove --yes \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin --filename=composer

RUN composer global require hirak/prestissimo

COPY composer.json composer.lock ./
RUN composer install -d .

ENV DEBIAN_FRONTEND=dialog
