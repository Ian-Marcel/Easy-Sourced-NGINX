#!/usr/bin/env bash

#### Error detector
set -euo pipefail
trap 'printf "\033[1;33mOps! \033[1;31m\b Something went wrong! \n\033[1;34mExiting...\033[0m\n"' INT TERM ERR
############

NC='\033[0m'			# No Color
BGREEN='\033[1;32m'		# Success Color
BlBLUE='\033[1;34m'		# Info Color
BCYAN='\033[1;36m'		# Link Color
BYELLOW='\033[1;33m'	# Warning Color
BRED='\033[1;31m'		# Error Color

source assets/source/progress_bar_by_task_completion.sh

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
echo -en "\n${BRED}Uninstalling${NC}"
echo -e "\t\b${BCYAN}$(cat tmp.old | awk -F ":" '{ print $2 }')${NC} \n"

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

