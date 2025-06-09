#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis não definidas

NC='\033[0m' # No Color
BCYAN='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'

trap 'echo -e "❌ ${BYELLOW}Error occurred! ${BCYAN}Exiting...${NC}"' ERR

echo -e "${BCYAN}Backing up current nginx configuration folder, ${BYELLOW}it requires root access! ${NC}"
sudo tar -zcf nginx-backup.tar.gz -C /etc/ nginx
source uninstall.sh
source install.sh
sudo rm -r /etc/nginx
sudo tar -zxf nginx-backup.tar.gz
sudo mv nginx /etc/
sudo rm nginx-backup.tar.gz
