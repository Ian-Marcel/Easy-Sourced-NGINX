#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis ​​não definidas

NORMAL='\033[0m' # No Color
BLBLUE='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'

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
    echo -e "${BGREEN}Successful directory check ${NORMAL} \n"
    chmod +x "$ESNx_ASSETS/source/"*.sh &&
        cd "$ESNx_TMP" || exit
else
    echo -e "${BRED}Directory verification failed ${NORMAL}" >&2
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

    ## Construindo e compilando a configuração NGINX #######################
    echo -e "${BGREEN}Package and modules obtained! ${BLBLUE}Configuring NGINX... ${NORMAL}" &&
    cd nginx-*.*.* || exit &&
    ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-http_v3_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --add-module=../nginx-dav-ext-module &&
    echo -e "${BGREEN}NGINX configured! ${BLBLUE}Compiling NGINX... ${NORMAL}" &&
    make &&
    echo -e -e "${BGREEN}NGINX compiled! ${BLBLUE}Installing NGINX... ${NORMAL}" &&
    sudo make install &&

    # Usar prefixo otimizado (OPCIONAL)
    source "$ESNx_ASSETS/source/better_prefix.sh" &&

    ## Finalizando instalação #######################
    source "$ESNx_ASSETS/source/final_touches.sh"
