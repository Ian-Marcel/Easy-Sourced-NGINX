#!/usr/bin/env bash

#### Error detector
set -euo pipefail
trap 'printf "\033[1;33mOps! \033[1;31m\b Something went wrong! \n\033[1;34mExiting...\033[0m\n"' INT TERM ERR
############

source "$LIBDIR"/colors
source "$LIBDIR"/wait_with_spinner_loading
source "$LIBDIR"/progress_bar_by_task_completion

rm_tasks=(
    "sudo systemctl disable --now nginx.service"
    "/usr/lib/nginx"
    "/etc/nginx"
    "/var/log/nginx"
    "/var/cache/nginx"
    "/var/www/nginx"
    "/usr/sbin/nginx"
    "/var/run/nginx.pid"
    "/var/run/nginx.lock"
    "/etc/systemd/system/nginx.service"
    "sudo systemctl daemon-reload"
)
sudo nginx -v &>tmp.old
echo -en "\n${BRED}Uninstalling${NC}"
echo -e "\t\b${BCYAN}$(cat tmp.old | awk -F ":" '{ print $2 }')${NC} \n"

total_tasks=$((${#rm_tasks[@]} - 1)) # comment.1
for current_task_index in "${!rm_tasks[@]}"; do
    if [[ "${rm_tasks[$current_task_index]}" = sudo* ]]; then
        progress_bar_by_task_completion "$current_task_index" "$total_tasks"
        ${rm_tasks[$current_task_index]} &>/dev/null
    else
        progress_bar_by_task_completion "$current_task_index" "$total_tasks"
        sudo rm -rf "${rm_tasks[$current_task_index]}"
    fi
done
