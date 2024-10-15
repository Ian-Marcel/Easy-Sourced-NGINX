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
    rm -rf tmp &&
    ## Mensagem pós-instalação #######################
    echo -e "
${BGREEN}...INSTALLATION COMPLETED SUCCESSFULLY!
${BBLUE}If you have chosen the optimized configuration, visit and read the
comments in ${BYELLOW}\"/etc/nginx/sites-available/default.conf\"${BBLUE} and
${BYELLOW}\"/etc/nginx/nginx.conf\"${BBLUE}, make the changes and restart nginx with: 

${BYELLOW}\"sudo systemctl restart nginx\""
