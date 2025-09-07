#!/usr/bin/env bash

echo -e "${BCYAN}Installing dependencies, ${BYELLOW}it requires root access! ${NC}"

source "$ESNx_ASSETS"/source/progress_bar_by_task_completion.sh
DISTRO_ID=$(grep -w ID /etc/os-release | awk -F= '{gsub(/"/, "", $2); print $2}')

sudo echo -ne "\n\b ${BCYAN}System: ${NC}"
if [ "$DISTRO_ID" = "debian" ] || [ "$DISTRO_ID" = "ubuntu" ]; then
	echo -e "\t${BGREEN}Debian family ( Debian, Ubuntu, Raspberry Pi OS ... ) ${NC} \n"
	source "$ESNx_ASSETS"/file/deb_dependecies.sh
	total_tasks=$(( ${#apt_tasks[@]} - 1 )) # comment.1
	for current_task_index in "${!apt_tasks[@]}"; do
		if [[ "${apt_tasks[$current_task_index]}" = sudo* ]]; then
			show_progress "$current_task_index" "$total_tasks"
			${apt_tasks[$current_task_index]} &>/dev/null
		else
			show_progress "$current_task_index" "$total_tasks"
			sudo apt-get --assume-yes install "${apt_tasks[$current_task_index]}" &>/dev/null
		fi
	done
elif [ "$DISTRO_ID" = "fedora" ] || [ "$DISTRO_ID" = "rocky" ] || [ "$DISTRO_ID" = "almalinux" ]; then
	echo -e "\t${BGREEN}Red Hat family ( Fedora, RHEL, CentOS ... ) ${NC} \n"
	source "$ESNx_ASSETS"/file/rpm_dependecies.sh
	total_tasks=$(( ${#dnf_tasks[@]} - 1 )) # comment.1
	for current_task_index in "${!dnf_tasks[@]}"; do
		if [[ "${dnf_tasks[$current_task_index]}" = sudo* ]]; then
			show_progress "$current_task_index" "$total_tasks"
			${dnf_tasks[$current_task_index]} &>/dev/null
		else
			show_progress "$current_task_index" "$total_tasks"
			sudo dnf install --assumeyes --quiet "${dnf_tasks[$current_task_index]}" &>/dev/null
		fi
	done
fi
