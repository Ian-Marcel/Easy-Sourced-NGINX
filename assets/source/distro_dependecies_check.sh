#!/usr/bin/env bash

echo "Installing dependencies requires root access!"

# Verificando se lsb_release está instalado
#if ! command -v lsb_release &>/dev/null; then
#    echo "Command 'lsb_release' NOT FOUND. Please INSTALL IT FIRST!" >&2
#    exit 1
#fi

DISTRO=$(grep -w ID /etc/os-release | awk -F= '{print $2}')

echo "System:"
if [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "ubuntu" ]; then
    echo "  Debian family ( Debian, Ubuntu, Proxmox ... )"
    sudo apt update -y && sudo apt upgrade -y &&
        sudo apt -y install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl3 libssl-dev libxml2 libxslt1-dev

elif [ "$DISTRO" = "fedora" ] || [ "$DISTRO" = "\"rocky\"" ] || [ "$DISTRO" = "\"alma\"" ]; then
    echo "  RHEL-family ( Fedora, RHEL, CentOS ... )"
    sudo dnf update -y &&
        sudo dnf -y group install "Development Tools" &&
        sudo dnf -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel libxml2 libxslt-devel

fi
