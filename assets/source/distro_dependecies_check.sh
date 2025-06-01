#!/usr/bin/env bash

echo -e "${BCYAN}Installing dependencies, ${BYELLOW}it requires root access! ${NC}"

source "$ESNx_ASSETS"/source/progress_bar.sh
DISTRO_ID=$(grep -w ID /etc/os-release | awk -F= '{gsub(/"/, "", $2); print $2}')

echo -e "\n${BCYAN}System: ${NC}"
if [ "$DISTRO_ID" = "debian" ] || [ "$DISTRO_ID" = "ubuntu" ]; then
	echo -e "\t${BGREEN}Debian family ( Debian, Ubuntu, Raspberry Pi OS ... ) ${NC} \n"
	source "$ESNx_ASSETS"/file/deb_dependecies.sh
	for current_task_index in "${!apt_tasks[@]}"; do
		if [ "$current_task_index" -ge 2 ]; then
			sudo apt-get --assume-yes install "${apt_tasks[$current_task_index]}" >/dev/null
			sleep 0.2
			show_progress "$current_task_index" "$(echo "${!apt_tasks[@]}" | awk '{ print $NF }')"
		else
			${apt_tasks[$current_task_index]} >/dev/null
			sleep 0.2
			show_progress "$current_task_index" "$(echo "${!apt_tasks[@]}" | awk '{ print $NF }')"
		fi
	done
elif [ "$DISTRO_ID" = "fedora" ] || [ "$DISTRO_ID" = "rocky" ] || [ "$DISTRO_ID" = "almalinux" ]; then
	echo -e "\t${BGREEN}Red Hat family ( Fedora, RHEL, CentOS ... ) ${NC} \n"
	source "$ESNx_ASSETS"/file/rpm_dependecies.sh
	for current_task_index in "${!dnf_tasks[@]}"; do
		if [ "$current_task_index" -ge 3 ]; then
			sudo dnf install --assumeyes --quiet "${dnf_tasks[$current_task_index]}" >/dev/null
			sleep 0.2
			show_progress "$current_task_index" "$(echo "${!dnf_tasks[@]}" | awk '{ print $NF }')"
		else
			${dnf_tasks[$current_task_index]} >/dev/null
			sleep 0.2
			show_progress "$current_task_index" "$(echo "${!dnf_tasks[@]}" | awk '{ print $NF }')"
		fi
	done
fi
