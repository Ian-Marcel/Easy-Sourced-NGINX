#!/usr/bin/env bash

set -euo pipefail

NC='\033[0m' # No Color
BCYAN='\033[1;36m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BRED='\033[1;31m'

source assets/source/progress_bar_by_task_completion.sh

trap 'echo -e "❌ ${BYELLOW}Error occurred! ${BCYAN}Exiting...${NC}"' ERR

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
sudo nginx -v &> tmp.old
echo -en "${BRED}Uninstalling${NC}"
echo -e "${BCYAN}$(<tmp.old)${NC}\n" | awk -F ":" '{ print $2 }'

total_tasks=$(( ${#rm_tasks[@]} - 1 )) # comment.1
for current_task_index in "${!rm_tasks[@]}"; do
	if [[ "${rm_tasks[$current_task_index]}" = sudo* ]]; then
		show_progress "$current_task_index" "$total_tasks"
		${rm_tasks[$current_task_index]} &>/dev/null
	else
		show_progress "$current_task_index" "$total_tasks"
		sudo rm -rf "${rm_tasks[$current_task_index]}"
	fi
done

