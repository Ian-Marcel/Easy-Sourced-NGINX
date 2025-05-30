#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis ​​não definidas

NC='\033[0m' # No Color
BCYAN='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'

trap 'echo -e "❌ ${BYELLOW}Error occurred! ${BCYAN}Exiting...${NC}"' ERR

sudo systemctl disable --now nginx.service 
    sudo rm -rf /usr/lib/nginx \
        /etc/nginx \
        /var/log/nginx \
        /var/cache/nginx \
        /var/www/nginx 
    sudo rm -f /usr/sbin/nginx \
        /var/run/nginx.pid \
        /var/run/nginx.lock \
        /etc/systemd/system/nginx.service 
    sudo systemctl daemon-reload
