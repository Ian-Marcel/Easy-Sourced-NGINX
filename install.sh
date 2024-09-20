#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis ​​não definidas

## Especificando variáveis iniciais #######################
mkdir -pv tmp assets

ESNx=$(pwd) &&
    export ESNx

cd assets &&
    ESNx_ASSETS=$(pwd) &&
    export ESNx_ASSETS &&
    cd "$ESNx" || exit

cd tmp &&
    ESNx_TMP=$(pwd) &&
    export ESNx_TMP &&
    cd "$ESNx" || exit

# Verificando se lsb_release está instalado
if ! command -v lsb_release &>/dev/null; then
    echo "Comando 'lsb_release' NÃO ENCONTRADO. Por favor, INSTALE-O PRIMEIRO!" >&2
    exit 1
else
    echo "Comando 'lsb_release' ENCONTRADO"
fi

DISTRO=$(lsb_release -i | awk '{print $3}') &&
    export DISTRO

## Verificando variáveis #######################
if [ "$(pwd)" = "$ESNx" ] && [ "$ESNx_ASSETS" = "$ESNx/assets" ] && [ "$ESNx_TMP" = "$ESNx/tmp" ]; then
    echo "Sucesso na verificação do diretório" && cd "$ESNx_TMP" || exit
else
    echo "Falha na verificação do diretório" >&2
    exit 1
fi

## Obtendo pacote nginx, dependências e modulos não oficiais #######################

echo \
    "
Instalando dependências, é necessário acesso ao root!

Sistema:"

if [ "$DISTRO" = "Debian" ] || [ "$DISTRO" = "Ubuntu" ]; then
    echo "  Debian-based ( Debian, Ubuntu, ... )
    "
    sudo apt -y install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl3 libssl-dev libxml2 libxslt1-dev # libxslt
elif [ "$DISTRO" = "Fedora" ]; then
    echo " Fedora-based ( Fedora, RHEL, ... )"
    sudo dnf install pcre pcre-devel zlib zlib-devel
fi

if ! cat /etc/passwd | grep nginx &>/dev/null; then
    echo \
        "
Usuário nginx NÃO ENCONTRADO!
Criando usuário..." &&
        sudo useradd -u 999 -d /nonexistent -s /bin/false -r -U -g 995 nginx &&
        echo \
            "
...Usuário nginx CRIADO com sucesso!
Continuando...
"
else
    echo \
        "
Usuário nginx ENCONTRADO!
Continuando...
"
fi

sudo mkdir -pv /usr/lib/nginx/modules /etc/nginx /var/log/nginx /var/cache/nginx &&
    sudo chown -R nginx:nginx /usr/lib/nginx/modules /etc/nginx /var/log/nginx /var/cache/nginx

echo "Dependências satisfeitas"

wget -i "$ESNx_ASSETS/packages.ini" &&
    find "$ESNx_TMP" -name "*.tar.gz" -exec tar -zxf {} + &&
    rm "$ESNx_TMP"/*.tar.gz &&
    git clone https://github.com/arut/nginx-dav-ext-module.git

cd nginx-*.*.* || exit

## Construindo e compilando a configuração NGINX #######################
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
    --add-module=../nginx-dav-ext-module
make &&
    sudo make install

## Finalizando instalação #######################
# Criando serviço para nginx
sudo cp "$ESNx_ASSETS/nginx.service" /usr/lib/systemd/system/ &&
    sudo systemctl daemon-reload &&
    sudo systemctl enable --now nginx.service
# Adicionando nginx ao grupo www-data
sudo usermod -aG www-data nginx &&
    sudo systemctl restart nginx.service
# Usar prefixo otimizado [depois...]

## Excluindo cache #######################
cd "$ESNx" &&
    rm -rf tmp

## Mensagem pós-instalação #######################
echo \
    "
...SUCESSO!
"
