#!/bin/sh

if [ ! -d "vendor" ]; then
    echo "vendor folder not found"
    composer install -d .
fi

if [ ! "$(ls -A vendor)" ]; then
    echo "vendor folder empty"
    composer install -d .
fi

php $@
