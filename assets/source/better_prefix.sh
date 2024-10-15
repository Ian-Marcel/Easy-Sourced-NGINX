#!/usr/bin/env bash

echo -e ''
shopt -s nocasematch
while true; do
    read -rp "${BBLUE}We offer an optimized nginx configuration, do you want it applied? [(Y)es/(n)o]: " NGINX_BETTER_PREFIX &&
        if [[ "$NGINX_BETTER_PREFIX" = Y ]] || [[ "$NGINX_BETTER_PREFIX" = Yes ]]; then
            echo -e "${BBLUE}Ok, applying new configuration..."
            sudo rm -rf /etc/nginx &&
                tar -zxf "$ESNx_ASSETS/file/nginx.tar.gz" &&
                sudo cp -r nginx /etc/
            sudo mkdir -p /var/www/nginx &&
                sudo cp "$ESNx_ASSETS/file/index.html" /var/www/nginx/ &&
                sudo cp "$ESNx_ASSETS/file/info.php" /var/www/nginx/ &&
                sudo chown -R nginx:nginx /var/www/nginx &&
                echo -e "${BGREEN}New configuration applied!"
            break
        elif [[ "$NGINX_BETTER_PREFIX" = N ]] || [[ "$NGINX_BETTER_PREFIX" = No ]]; then
            echo -e "${BBLUE}Ok, continuing with default configuration!"
            break
        else
            echo -e "${BYELLOW}Please answer with (Y)es or (N)o."
        fi
done
shopt -u nocasematch
