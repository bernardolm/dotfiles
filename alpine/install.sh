#!/bin/sh
echo "welcome to alpine install"

repositories="
http://alpinelinux.c3sl.ufpr.br/latest-stable/community
http://alpinelinux.c3sl.ufpr.br/latest-stable/main
http://alpinelinux.c3sl.ufpr.br/v3.15/community
http://alpinelinux.c3sl.ufpr.br/v3.15/main
http://alpinelinux.c3sl.ufpr.br/v3.16/community
http://alpinelinux.c3sl.ufpr.br/v3.16/main
"
echo "$repositories" | tee -a /etc/apk/repositories

modules="
i2c_dev
w1-gpio
w1-therm
"
echo "$modules" | tee -a /etc/apk/modules

apk update
apk add $(cat packages.txt) && echo "done"
