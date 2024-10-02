#!/usr/bin/env bash

echo "Dependencies satisfied. Getting NGINX package and extra unofficial modules..."
wget -i "$ESNx_ASSETS/file/packages.ini" &&
    find "$ESNx_TMP" -name "*.tar.gz" -exec tar -zxf {} + &&
    rm "$ESNx_TMP"/*.tar.gz &&
    git clone https://github.com/arut/nginx-dav-ext-module.git