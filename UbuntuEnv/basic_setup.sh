#!/usr/bin/bash

aptInstall() {
	aptApps=( openssh-server terminator nodejs git net-tools nmap unattended-upgrades libpam-pwquality python3 python3-pip curl default-jre openjdk-11-jre-headless openjdk-8-jre-headless hhvm )
	for app in "${aptApps[@]}"
	do
		echo "[*] Installing: $app";
		/usr/bin/sudo /usr/bin/apt install $app -y 2> /dev/null 
		installSuccess $? $app
	done
}

pipInstall() {
	pipApps=( flask )
	for app in "${pipApps[@]}"
	do
		echo "[*] Installing: $app";
		/usr/bin/pip3 install $app 2> /dev/null
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
	source ~/.bash_profile
	git config --global user.name "$GITUSER"
	git config --global user.email "$GITEMAIL"
}

main() {
	echo "System Update and Upgrade"
	/usr/bin/sudo apt-get update -y && sudo apt-get upgrade -y
	installSuccess $? "System Upgrades and Updates"
	
	echo "[*] Installing 'apt' Tools"
	aptInstall

	echo "[*] Installing 'pip3' Tools"
	pipInstall
	
	config_git
	
	/usr/bin/sudo /bin/systemctl status ssh
}

main
