#!/usr/bin/env bash

set -euo pipefail # Sair em caso de erro e falha em variáveis ​​não definidas

## Especificando variáveis #######################
mkdir -pv tmp assets &&
    ESNx=$(pwd) &&
    cd assets &&
    ESNx_ASSETS=$(pwd) &&
    cd "$ESNx" &&
    cd tmp &&
    ESNx_TMP=$(pwd) &&
    cd "$ESNx" || exit
# Verificando variáveis
if [ "$(pwd)" = "$ESNx" ] && [ "$ESNx_ASSETS" = "$ESNx/assets" ] && [ "$ESNx_TMP" = "$ESNx/tmp" ]; then
    echo "Sucesso na verificação do diretório"
    chmod +x "$ESNx_ASSETS/source/"*.sh &&
        cd "$ESNx_TMP" || exit
else
    echo "Falha na verificação do diretório" >&2
    exit 1
fi

## Obtendo NGINX, dependências e modulos extras não oficiais #######################
echo "Instalando dependências, é necessário acesso ao root!"
# Checando distribuição para dependências
source "$ESNx_ASSETS/source/distro_dependecies_check.sh"
# Checando usuário
source "$ESNx_ASSETS/source/user_check.sh"
# Criando caminhos do nginx
source "$ESNx_ASSETS/source/mkdir_paths.sh"
echo "Dependências satisfeitas. Obtendo pacote NGINX e modulos extras não oficiais..."
wget -i "$ESNx_ASSETS/file/packages.ini" &&
    find "$ESNx_TMP" -name "*.tar.gz" -exec tar -zxf {} + &&
    rm "$ESNx_TMP"/*.tar.gz &&
    git clone https://github.com/arut/nginx-dav-ext-module.git
echo 'Pacote e modulos obtidos! Configurando NGINX...'

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
    --add-module=../nginx-dav-ext-module &&
    echo 'NGINX configurado! Compilando NGINX...'
make &&
    echo 'NGINX compilado! Instalando NGINX...' &&
    sudo make install

## Finalizando instalação #######################
source "$ESNx_ASSETS/source/final_touches.sh"
# Usar prefixo otimizado (OPCIONAL)
echo ''
source "$ESNx_ASSETS/source/better-prefix.sh"

## Apagando dados residuais #######################
cd "$ESNx" &&
    rm -rf tmp

## Mensagem pós-instalação #######################
echo '
...INSTALAÇÃO CONCLUÍDA COM SUCESSO! Caso tenha optado pela configuração otimizada visite e leia os comentários em
"/etc/nginx/sites-available/default.conf" e "/etc/nginx/nginx.conf", efetue as mudanças necessárias e
reinicie nginx com:

"sudo systemctl restart nginx" 
'
