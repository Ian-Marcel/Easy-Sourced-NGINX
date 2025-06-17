#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis não definidas

NC='\033[0m' # No Color
BCYAN='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'
CURL_ESX=2

trap 'echo -e "❌ ${BYELLOW}Error occurred! ${BCYAN}Exiting...${NC}"' ERR

echo -e "${BCYAN}Backing up current nginx configuration folder, ${BYELLOW}it requires root access! ${NC}"
sudo -v

sudo tar -zcf nginx-backup.tar.gz -C /etc/ nginx

source uninstall.sh
source install.sh

sudo rm -r /etc/nginx
sudo tar -zxf nginx-backup.tar.gz
sudo cp -a nginx /etc/
sudo rm -rf nginx nginx-backup.tar.gz
