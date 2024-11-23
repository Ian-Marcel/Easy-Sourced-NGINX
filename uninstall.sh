#!/usr/bin/env bash

sudo systemctl disable --now nginx.service &&
    sudo rm -rf /usr/lib/nginx \
        /etc/nginx \
        /var/log/nginx \
        /var/cache/nginx \
        /var/www/nginx &&
    sudo rm -f /usr/sbin/nginx \
        /var/run/nginx.pid \
        /var/run/nginx.lock \
        /etc/systemd/system/nginx.service &&
    sudo systemctl daemon-reload
