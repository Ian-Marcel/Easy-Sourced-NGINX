#!/usr/bin/env bash

if ! grep -q nginx /etc/passwd; then
    echo -e "${BYELLOW}Nginx user NOT FOUND! Creating user... ${NC}"
    sudo useradd -d /nonexistent -s /bin/false -r -U nginx &&
        echo -e "${BGREEN}Nginx user CREATED successfully! ${NC}"
else
    echo -e "${BGREEN}Nginx user FOUND! ${NC}"
fi
