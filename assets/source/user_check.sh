#!/usr/bin/env bash

if ! grep -q nginx /etc/passwd; then
    echo "Usuário nginx NÃO ENCONTRADO! Criando usuário..."
    sudo useradd -d /nonexistent -s /bin/false -r -U nginx &&
        echo "Usuário nginx CRIADO com sucesso!"
else
    echo "Usuário nginx ENCONTRADO!"
fi
