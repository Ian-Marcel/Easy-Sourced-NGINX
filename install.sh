#!/usr/bin/env bash

set -euo pipefail  # Sair em caso de erro e falha em variáveis ​​não definidas

# Especificando variáveis iniciais
mkdir -pv tmp assets;

ESNx=$(pwd) && \
    export ESNx;

cd assets && \
ESNx_ASTS=$(pwd) && \
    export ESNx_ASTS && \
        cd "$ESNx" || exit;

cd tmp && \
    ESNx_TMP=$(pwd) && \
        export ESNx_TMP && \
            cd "$ESNx" || exit ;

# Verificando variáveis
if [ "$(pwd)" = "$ESNx" ] && [ "$ESNx_ASTS" = "$ESNx/assets" ] && [ "$ESNx_TMP" = "$ESNx/tmp" ]; then
    echo "good to go!" && cd "$ESNx_TMP" || exit
else
    echo "Falha na verificação do diretório" >&2
    exit 1
fi

## Obtendo pacote nginx e modulos não oficiais
    wget -i "$ESNx_ASTS/Dependencies.txt" && \
    tar -zxf nginx-1.26.2.tar.gz && \
        rm nginx-1.26.2.tar.gz && \
    tar -zxf zlib-1.3.1.tar.gz && \
        rm zlib-1.3.1.tar.gz && \
    tar -zxf pcre2-10.44.tar.gz && \
        rm pcre2-10.44.tar.gz && \
    tar -zxf openssl-3.3.2.tar.gz && \
        rm openssl-3.3.2.tar.gz && \
    cd nginx-1.26.2 || exit;

## Construindo a configuração NGINX
./configure \
    --with-zlib="$ESNx_TMP/zlib-1.3.1" \
    --with-pcre="$ESNx_TMP/pcre2-10.44" \
    --with-pcre-jit \
    --with-openssl="$ESNx_TMP/openssl-3.3.2" \
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
    --add-module="$ESNx_TMP/nginx-dav-ext-module" ;

## Compilando NGINX
make
sudo make install;

## Criando serviço para nginx
sudo cp "$ESNx_ASTS/nginx.service" /usr/lib/systemd/system/ && \
    sudo systemctl daemon-reload
