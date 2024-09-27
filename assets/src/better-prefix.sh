#!/usr/bin/env bash

shopt -s nocasematch &&
    if [ "$LANG" = pt_BR.UTF-8 ]; then
        while true; do
            read -rp "Oferemos uma configuração otimizada do nginx, quer que seja aplicada? [(S)im/(n)ão]: " NGINX_BETTER_PREFIX &&
                if [ "$NGINX_BETTER_PREFIX" = S ] || [ "$NGINX_BETTER_PREFIX" = Sim ]; then
                    echo "Ok, aplicando nova configuração..."
                    sudo rm -rf /etc/nginx &&
                        tar -zxf "$ESNx_ASSETS/nginx.tar.gz" &&
                        sudo cp -r nginx /etc/
                    sudo mkdir -p /var/www/nginx &&
                        sudo cp "$ESNx_ASSETS/index.html" /var/www/nginx/ &&
                        chown -R nginx:nginx /var/www/nginx &&
                        sudo systemctl restart nginx &&
                        echo "...Nova configuração aplicada!"
                    break
                elif [ "$NGINX_BETTER_PREFIX" = N ] || [ "$NGINX_BETTER_PREFIX" = Não ]; then
                    echo "Ok, continuando com configuração padrão!"
                    break
                else
                    echo "Por favor, responda com (S)im ou (n)ão."
                fi
        done
#    else
#        while true; do
#            read -rp "We provide an optimized nginx configuration, do you want it applied? [(Y)es/(n)o]: " NGINX_BETTER_PREFIX &&
#                if [ "$NGINX_BETTER_PREFIX" = Y ] || [ "$NGINX_BETTER_PREFIX" = Yes ]; then
#                    echo "Ok, applying new configuration..."
#                    sudo rm -rf /etc/nginx &&
#                        tar -zxf "$ESNx_ASSETS/nginx.tar.gz" &&
#                        sudo cp -r nginx /etc/
#                    sudo mkdir -p /var/www/nginx &&
#                        sudo cp "$ESNx_ASSETS/index.html" /var/www/nginx/ &&
#                        chown -r nginx:nginx /var/www/nginx &&
#                        sudo systemctl restart nginx &&
#                        echo "...New configuration applied!"
#                    break
#                elif [ "$NGINX_BETTER_PREFIX" = N ] || [ "$NGINX_BETTER_PREFIX" = No ]; then
#                    echo "Ok, continuing with default configuration!"
#                    break
#                else
#                    echo "Please answer with (Y)es or (n)o."
#                fi
#        done
    fi &&
    shopt -u nocasematch