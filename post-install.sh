#!/bin/bash

# Usage example. Notice this scritp is mandatory to be run as SUDO user: post-install.sh

# Colors: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
NC='\033[0m' # No Color
# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
# Bold
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

if [[ $EUID -ne 0 ]]; then
   	printf "${BRed}This script must be run as root \n" 
   	exit 1
else
	if ! dpkg -s dialog >/dev/null 2>&1; then
		echo "dialog is missing, installing ..."
		apt install -y dialog
		echo "OK-dialgo is installed."
	fi
	
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	# package name | Shrot description for this pakcage | flag for checkbox bu default
	options=(
		Update "apt update" off
		htop "System monitor tool" off
	)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	clear
	for choice in $choices
	do
		case $choice in
		'Update')
			echo "running apt update"
			apt update
			#apt update && sudo apt-get upgrade -y
			;;
		"htop")
			apt install -y htop
			printf "${Green}* Htop is installed \n"
			;;
		esac
	done
fi