#!/usr/bin/env bash

## Resolvendo dependências
sudo apt install -y nala && \
    sudo nala install -y libxml2;
## Obtendo pacote nginx e modulos não oficiais
mkdir -pv tmp && cd tmp || exit && \
    wget https://nginx.org/download/nginx-1.26.2.tar.gz && \
    wget https://zlib.net/zlib-1.3.1.tar.gz && \
    wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.gz && \
    wget https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz && \
    git clone https://github.com/arut/nginx-dav-ext-module.git && \
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
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --with-zlib=../zlib-1.3.1 \
    --with-pcre=../pcre2-10.44 \
    --with-pcre-jit \
    --with-openssl=../openssl-3.3.2 \
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
    --add-module=../nginx-dav-ext-module \
    --with-cc-opt='-g -O2 -ffile-prefix-map=/data/builder/debuild/nginx-1.26.2/debian/debuild-base/nginx-1.26.2=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie';
## Compilando NGINX
make && sudo make install;
## Criando serviço para nginx
sudo cp ../../assets/nginx.service
    sudo systemctl daemon-reload