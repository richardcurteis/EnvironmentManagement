#!/usr/bin/bash

aptInstall() {
	aptApps=( terminator nodejs git net-tools nmap unattended-upgrades libpam-pwquality python3 python3-pip curl default-jre openjdk-11-jre-headless openjdk-8-jre-headless hhvm )
	for app in "${aptApps[@]}"
	do
		echo "[*] Installing: $app";
		/usr/bin/sudo /usr/bin/apt install $app -y 2> /dev/null 
		installSuccess $? $app
	done
}

pipInstall() {
	pipApps=( Flask )
	for app in "${pipApps[@]}"
	do
		echo "[*] Installing: $app";
		/usr/bin/pip install $app 2> /dev/null
		installSuccess $? $app
	done
}

installSuccess() {
	if [ $1 -eq 0 ]; then
    		echo 
	else
    		echo "[X] Install Failed: $2"
	fi
}

config_git() {
	git config --global user.name "$GITUSER"
	git config --global user.email "$GIT_EMAIL"
}

main() {
	echo "System Update and Upgrade"
	/usr/bin/sudo apt-get update && sudo apt-get upgrade
	installSuccess $? "System Upgrades and Updates"
	
	echo "[*] Installing 'apt' Tools"
	aptInstall

	echo "[*] Installing 'pip' Tools"
	pipInstall
	
	config_git
}

main
