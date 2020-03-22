#!/usr/bin/bash

aptInstall() {
	aptApps=( terminator tmux nodejs git net-tools nmap unattended-upgrades zsh libpam-pwquality python-pip curl sqlmap default-jre openjdk-11-jre-headless openjdk-8-jre-headless golang-go gccgo-go ruby php7.2-cli hhvm )
	for app in "${aptApps[@]}"
	do
		echo "\n[*] Installing: $app";
		/usr/bin/sudo /usr/bin/apt install $app -y 2>&1/dev/null 
		installSuccess $?
	done
}

pipInstall() {
	pipApps=( setuptools sslyze scapy )
	for app in "${pipApps[@]}"
	do
		echo "\n[*] Installing: $app";
		/usr/bin/pip install $app 2>&1/dev/null
		installSuccess $?
	done
}

installSuccess() {
	if [ $1 -eq 0 ]; then
    		echo "\n[!] Install Successful: $app"
	else
    		echo "\n[X] Install Failed: $app"
	fi
}

main() {
	echo "System Update and Upgrade"
	/usr/bin/sudo apt update && sudo apt upgrade
	installSuccess $?
	
	echo "\n[*] Installing 'apt' Tools\n"
	aptInstall()

	echo "\n[*] Installing 'pip' Tools\n"
	pipInstall()
}

main()