#!/usr/bin/env bash

sudo systemctl disable --now nginx.service
sudo rm -rf /usr/lib/nginx
sudo rm -rf /etc/nginx
sudo rm -rf /var/log/nginx
sudo rm -rf /var/cache/nginx
sudo rm -rf /var/www/nginx
sudo rm -f /usr/sbin/nginx
sudo rm -f /var/run/nginx.pid
sudo rm -f /var/run/nginx.lock
sudo rm -f /etc/systemd/system/nginx.service
sudo systemctl daemon-reload
