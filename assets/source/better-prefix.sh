#!/usr/bin/env bash

shopt -s nocasematch &&
    while true; do
        read -rp "Oferemos uma configuração otimizada do nginx, quer que seja aplicada? [(S)im/(n)ão]: " NGINX_BETTER_PREFIX &&
            if [ "$NGINX_BETTER_PREFIX" = S ] || [ "$NGINX_BETTER_PREFIX" = Sim ]; then
                echo "Ok, aplicando nova configuração..."
                sudo rm -rf /etc/nginx &&
                    tar -zxf "$ESNx_ASSETS/file/nginx.tar.gz" &&
                    sudo cp -r nginx /etc/
                sudo mkdir -p /var/www/nginx &&
                    sudo cp "$ESNx_ASSETS/file/index.html" /var/www/nginx/ &&
                    sudo chown -R nginx:nginx /var/www/nginx &&
                    echo "...Nova configuração aplicada!"
                break
            elif [ "$NGINX_BETTER_PREFIX" = N ] || [ "$NGINX_BETTER_PREFIX" = Não ]; then
                echo "Ok, continuando com configuração padrão!"
                break
            else
                echo "Por favor, responda com (S)im ou (n)ão."
            fi
    done &&
shopt -u nocasematch
