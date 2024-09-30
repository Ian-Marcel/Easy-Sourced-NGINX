#!/usr/bin/env bash

# Verificando se lsb_release está instalado
if ! command -v lsb_release &>/dev/null; then
    echo "Comando 'lsb_release' NÃO ENCONTRADO. Por favor, INSTALE-O PRIMEIRO!" >&2
    exit 1
fi

DISTRO=$(lsb_release -i | awk '{print $3}')

echo "Sistema:"
if [ "$DISTRO" = "Debian" ] || [ "$DISTRO" = "Ubuntu" ]; then
    echo "  Debian-based ( Debian, Ubuntu, ... )
    "
    sudo apt -y install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl3 libssl-dev libxml2 libxslt1-dev
elif [ "$DISTRO" = "Fedora" ]; then
    echo " Fedora-based ( Fedora, RHEL, ... )"
    sudo dnf install pcre pcre-devel zlib zlib-devel
fi
