#!/usr/bin/env bash

echo ''
shopt -s nocasematch
while true; do
    read -rp "We offer an optimized nginx configuration, do you want it applied? [(Y)es/(n)o]: " NGINX_BETTER_PREFIX &&
        if [ "$NGINX_BETTER_PREFIX" = Y ] || [ "$NGINX_BETTER_PREFIX" = Yes ]; then
            echo "Ok, applying new configuration..."
            sudo rm -rf /etc/nginx &&
                tar -zxf "$ESNx_ASSETS/file/nginx.tar.gz" &&
                sudo cp -r nginx /etc/
            sudo mkdir -p /var/www/nginx &&
                sudo cp "$ESNx_ASSETS/file/index.html" /var/www/nginx/ &&
                sudo chown -R nginx:nginx /var/www/nginx &&
                echo "New configuration applied!"
            break
        elif [ "$NGINX_BETTER_PREFIX" = N ] || [ "$NGINX_BETTER_PREFIX" = No ]; then
            echo "Ok, continuing with default settings!"
            break
        else
            echo "Please answer with (Y)es or (N)o."
        fi
done
shopt -u nocasematch
