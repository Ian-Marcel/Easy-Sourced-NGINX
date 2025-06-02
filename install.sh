#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis ​​não definidas

NC='\033[0m' # No Color
BCYAN='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'

trap 'echo -e "❌ ${BYELLOW}Error occurred.${BCYAN} Exiting.${NC}"; exit' ERR

## Designando variáveis de ambiente #######################
mkdir -p tmp assets &&
    ESNx=$(pwd) &&
    cd assets &&
    ESNx_ASSETS=$(pwd) &&
    cd "$ESNx" &&
    cd tmp &&
    ESNx_TMP=$(pwd) &&
    cd "$ESNx" || exit
# Verificando variáveis
if [ "$(pwd)" = "$ESNx" ] && [ "$ESNx_ASSETS" = "$ESNx/assets" ] && [ "$ESNx_TMP" = "$ESNx/tmp" ]; then
    echo -e "${BGREEN}Successful directory check ${NC} \n"
    chmod +x "$ESNx_ASSETS/source/"*.sh &&
        cd "$ESNx_TMP" || exit
else
    echo -e "${BRED}Directory verification failed ${NC}" >&2
    exit
fi

## Obtendo NGINX, dependências e modulos extras não oficiais #######################
# Checando distribuição para dependências
	source "$ESNx_ASSETS/source/distro_dependecies_check.sh" &&
# Checando usuário
    source "$ESNx_ASSETS/source/user_check.sh" &&
# Criando caminhos do nginx
    source "$ESNx_ASSETS/source/mkdir_paths.sh" &&
# Obtendo o pacote NGINX e módulos extras não oficiais
    source "$ESNx_ASSETS/source/downloading_packages.sh" &&

## Instalando NGINX #######################
    source "$ESNx_ASSETS/source/installation.sh" &&

# Usar prefixo otimizado (OPCIONAL)
    source "$ESNx_ASSETS/source/better_prefix.sh" &&

## Finalizando instalação #######################
    source "$ESNx_ASSETS/source/final_touches.sh"
