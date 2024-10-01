#!/usr/bin/env bash

if ! grep -q nginx /etc/passwd; then
    echo "Nginx user NOT FOUND! Creating user..."
    sudo useradd -d /nonexistent -s /bin/false -r -U nginx &&
        echo "Nginx user CREATED successfully!"
else
    echo "Nginx user FOUND!"
fi
