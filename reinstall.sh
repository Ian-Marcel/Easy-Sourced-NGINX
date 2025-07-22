#!/usr/bin/env bash

#### Error detector
set -euo pipefail
trap 'printf "\033[1;33mOps! \033[1;31m\b Something went wrong! \n\033[1;34mExiting...\033[0m\n"' INT TERM ERR
############

NC='\033[0m'			# No Color
BGREEN='\033[1;32m'		# Success Color
BlBLUE='\033[1;34m'		# Info Color
BCYAN='\033[1;36m'		# Link Color
BYELLOW='\033[1;33m'	# Warning Color
BRED='\033[1;31m'		# Error Color

echo -e "${BCYAN}Backing up current nginx configuration folder, ${BYELLOW}it requires root access! ${NC}"
sudo -v

sudo tar -zcf nginx-backup.tar.gz -C /etc/ nginx

source uninstall.sh
source install.sh

sudo rm -r /etc/nginx
sudo tar -zxf nginx-backup.tar.gz
sudo cp -a nginx /etc/
sudo rm -rf nginx nginx-backup.tar.gz
