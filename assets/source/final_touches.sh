#!/usr/bin/env bash

# Criando serviço para nginx
sudo cp "$ESNx_ASSETS/file/nginx.service" /usr/lib/systemd/system/ &&
    sudo systemctl daemon-reload &&
    sudo systemctl enable --now nginx &&
    # Adicionando nginx ao grupo www-data
    if ! sudo usermod -aG www-data nginx; then
        sudo usermod -aG apache nginx
    fi &&

    ## Apagando dados residuais #######################
    cd "$ESNx" &&
    rm -rf tmp

## Mensagem pós-instalação #######################
shopt -s nocasematch
if [[ "$NGINX_BETTER_PREFIX" = Y ]] || [[ "$NGINX_BETTER_PREFIX" = Yes ]]; then
    echo -e "
${BGREEN}...INSTALLATION COMPLETED SUCCESSFULLY!
\n${BCYAN}Since you have chosen the optimized configuration, visit and read the
comments in ${BYELLOW}\"/etc/nginx/sites-available/default.conf\"${BCYAN} and
${BYELLOW}\"/etc/nginx/nginx.conf\"${BCYAN}, make the changes and restart nginx with: 
\n${BYELLOW}\"sudo systemctl restart nginx\" ${NC}\n"
elif [[ "$NGINX_BETTER_PREFIX" = N ]] || [[ "$NGINX_BETTER_PREFIX" = No ]]; then
    echo -e "
${BGREEN}...INSTALLATION COMPLETED SUCCESSFULLY!${NC}
"
fi
shopt -u nocasematch
