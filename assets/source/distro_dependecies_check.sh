#!/usr/bin/env bash

echo -e "${BCYAN}Installing dependencies, ${BYELLOW}it requires root access! ${NC}"

DISTRO_ID=$(grep -w ID /etc/os-release | awk -F= '{gsub(/"/, "", $2); print $2}')

echo -e "\n ${BCYAN}System: ${NC}"
if [ "$DISTRO_ID" = "debian" ] || [ "$DISTRO_ID" = "ubuntu" ]; then
    echo -e "  ${BGREEN}Debian family ( Debian, Ubuntu, Raspberry Pi OS ... ) ${NC}"
    sudo apt update -y && sudo apt upgrade -y &&
        sudo apt -y install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl3 libssl-dev libxml2 libxslt1-dev

elif [ "$DISTRO_ID" = "fedora" ] || [ "$DISTRO_ID" = "rocky" ] || [ "$DISTRO_ID" = "almalinux" ]; then
    echo -e "  ${BGREEN}Red Hat family ( Fedora, RHEL, CentOS ... ) ${NC}"
    sudo dnf update -y &&
        sudo dnf -y group install "Development Tools" &&
        sudo dnf -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel libxml2 libxslt-devel

fi
