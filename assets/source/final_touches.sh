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
    source "$ESNx_ASSETS/source/final_message.sh"
