#!/usr/bin/env bash

#### Error detector
set -euo pipefail
trap 'printf "\033[1;33mOps! \033[1;31m\b Something went wrong! \n\033[1;34mExiting...\033[0m\n"' INT TERM ERR

## Designando variáveis de ambiente #######################
ROOTDIR="$PWD"

if [ "$(basename $ROOTDIR)" != "Easy-Sourced-NGINX" ]; then
    printf "(Error):\t Script isn't being executed in the correct place! \n"
    sleep 0.5s
    printf "(Info):\t\t Executed in: %s \n" "$PWD"
    sleep 3s
    exit 1
fi

mkdir -p tmp logs

APPDIR="$ROOTDIR/app"
WORKDIR="$ROOTDIR/tmp"

LIBDIR="$APPDIR/lib"
CONTENTDIR="$APPDIR/files"

LOGDIR="$ROOTDIR/logs"

source "$LIBDIR"/colors
source "$LIBDIR"/wait_with_spinner_loading
source "$LIBDIR"/progress_bar_by_task_completion

cd "$WORKDIR"
## Obtendo NGINX, dependências e modulos extras não oficiais #######################
# Checando distribuição para dependências
echo -e "${BCYAN}Installing dependencies, ${BYELLOW}it requires root access! ${NC}"
DISTRO_ID=$(grep -w ID /etc/os-release | awk -F= '{gsub(/"/, "", $2); print $2}')
echo -ne "\n\b ${BCYAN}System: ${NC}"
if [ "$DISTRO_ID" = "debian" ] || [ "$DISTRO_ID" = "ubuntu" ]; then
    echo -e "\t${BGREEN}Debian family ( Debian, Ubuntu, Raspberry Pi OS ... ) ${NC} \n "
    source "$CONTENTDIR/dependecies/apt.list"

    total_tasks=$((${#apt_tasks[@]} - 1)) # comment.1
    for current_task_index in "${!apt_tasks[@]}"; do
        if [[ "${apt_tasks[$current_task_index]}" = sudo* ]]; then
            progress_bar_by_task_completion "$current_task_index" "$total_tasks"
            ${apt_tasks[$current_task_index]} &>/dev/null
        else
            progress_bar_by_task_completion "$current_task_index" "$total_tasks"
            sudo apt-get --assume-yes install "${apt_tasks[$current_task_index]}" &>/dev/null
        fi
    done

elif [ "$DISTRO_ID" = "fedora" ] || [ "$DISTRO_ID" = "rocky" ] || [ "$DISTRO_ID" = "almalinux" ]; then
    echo -e "\t${BGREEN}Red Hat family ( Fedora, RHEL, CentOS ... ) ${NC} \n "
    source "$CONTENTDIR/dependecies/dnf.list"
    total_tasks=$((${#dnf_tasks[@]} - 1)) # comment.1
    for current_task_index in "${!dnf_tasks[@]}"; do
        if [[ "${dnf_tasks[$current_task_index]}" = sudo* ]]; then
            progress_bar_by_task_completion "$current_task_index" "$total_tasks"
            ${dnf_tasks[$current_task_index]} &>/dev/null
        else
            progress_bar_by_task_completion "$current_task_index" "$total_tasks"
            sudo dnf install --assumeyes --quiet "${dnf_tasks[$current_task_index]}" &>/dev/null
        fi
    done
fi

# Checando usuário
if ! grep -q nginx /etc/passwd; then
    echo -e "\n${BYELLOW}Nginx user NOT FOUND! Creating user... ${NC} "
    sudo useradd -d /nonexistent -s /bin/false -r -U nginx
    echo -e "${BGREEN}Nginx user CREATED successfully! ${NC} \n"
else
    echo -e "\n${BGREEN}Nginx user FOUND! ${NC}\n"
fi

# Criando caminhos do nginx
sudo mkdir -p \
    /etc/nginx \
    /var/log/nginx/ \
    /var/cache/nginx/ \
    /usr/lib/nginx/modules
sudo chown -R nginx:nginx \
    /etc/nginx \
    /var/log/nginx/ \
    /var/cache/nginx/ \
    /usr/lib/nginx/modules

# Obtendo o pacote NGINX e módulos extras não oficiais
echo -e "${BGREEN}Dependencies satisfied. ${BCYAN}Getting NGINX package and extra unofficial modules... ${NC} \n"
wget --directory-prefix "$WORKDIR" --quiet --input-file "$CONTENTDIR/dependecies/nginx.list"
for tarballs in *.tar.gz; do
    tar -zxf "$tarballs"
    rm "$tarballs"
done

## Instalando NGINX #######################
## Construindo, compilando e instalando a configuração NGINX #######################
cd nginx-1.28.0 || exit

./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx \
    --group=nginx \
    --build=easy_sourced_1.28.0-"$DISTRO_ID" \
    --builddir=nginx-1.28.0 \
    --with-threads \
    --with-file-aio \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module \
    --with-http_geoip_module=dynamic \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_auth_request_module \
    --with-http_random_index_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_realip_module \
    --with-stream_geoip_module=dynamic \
    --with-stream_ssl_preread_module \
    --with-pcre-jit \
    --with-compat \
    --add-module=../nginx-dav-ext-module-4.0.1 \
    --add-module=../headers-more-nginx-module-0.38 \
    &>"$LOGDIR/configure.log" &
wait_with_spinner_loading "Package and modules obtained! Configuring NGINX..."

make &>"$LOGDIR/make.log" &
wait_with_spinner_loading "NGINX configured! Compiling NGINX..."

sudo make install &>"$LOGDIR/make-install.log" &
wait_with_spinner_loading "NGINX compiled! Installing NGINX..."

# Usar prefixo otimizado (OPCIONAL)
while true; do
    if [ "${CURL_ESX-}" ] && [ "$CURL_ESX" -eq 2 ]; then
        NGINX_BETTER_PREFIX='No'
        break
    else
        read -rp $'\033[1;33mWe offer an optimized nginx configuration, do you want it applied? \033[1;36m[(Y)es/(n)o]: \033[1;0m' NGINX_BETTER_PREFIX
        case "$NGINX_BETTER_PREFIX" in
        Y | y | Yes | yes)
            echo -e "\n${BCYAN}Ok, applying new configuration... ${NC}"
            sudo rm -rf /etc/nginx
            sudo tar -zxf "$CONTENTDIR/nginx.tar.gz"
            sudo cp -r nginx /etc/
            sudo mkdir -p /var/www/nginx
            sudo cp "$CONTENTDIR"/www/{index.html,info.php} /var/www/nginx/
            sudo chown -R nginx:nginx /var/www/nginx
            echo -e "${BGREEN}New configuration applied! ${NC} \n"
            break
            ;;
        N | n | No | no)
            echo -e "\n${BCYAN}Ok, continuing with default configuration! ${NC} \n"
            break
            ;;
        *)
            echo -e "${BYELLOW}Please answer with (Y)es or (N)o. ${NC}"
            ;;
        esac

    fi
done

## Finalizando instalação #######################
# Criando serviço para nginx
sudo cp "$CONTENTDIR/systemd/nginx.service" /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now nginx
# Adicionando nginx ao grupo www-data
if ! sudo usermod -aG www-data nginx &>/dev/null; then
    sudo usermod -aG apache nginx
fi

## Apagando dados residuais #######################
cd "$ROOTDIR"
rm -rf tmp

## Mensagem pós-instalação #######################
case "$NGINX_BETTER_PREFIX" in
Y | y | Yes | yes)
    printf "${BGREEN}INSTALLATION COMPLETED SUCCESSFULLY!
    \r\n${BCYAN}Since you have chosen the optimized configuration, visit and read the
    \rcomments in ${BYELLOW}\"/etc/nginx/sites-available/default.conf\"${BCYAN} and
    \r${BYELLOW}\"/etc/nginx/nginx.conf\"${BCYAN}, make the changes and restart nginx with: 
    \r\n${BYELLOW}\"sudo systemctl restart nginx\" ${NC}\n"
    ;;
N | n | No | no)
    echo -e "${BGREEN}INSTALLATION COMPLETED SUCCESSFULLY! ${NC}"
    ;;
esac
