#!/usr/bin/bash

aptInstall() {
	aptApps=( terminator tmux nodejs git net-tools nmap unattended-upgrades zsh libpam-pwquality python-pip curl sqlmap default-jre openjdk-11-jre-headless openjdk-8-jre-headless golang-go gccgo-go ruby php7.2-cli hhvm )
	for app in "${aptApps[@]}"
	do
		echo "\n[*] Installing: $app";
		/usr/bin/sudo /usr/bin/apt install $app -y 2>&1/dev/null 
		installSuccess $? $app
	done
}

pipInstall() {
	pipApps=( setuptools sslyze scapy )
	for app in "${pipApps[@]}"
	do
		echo "\n[*] Installing: $app";
		/usr/bin/pip install $app 2>&1/dev/null
		installSuccess $? $app
	done
	echo "[#] Special Install Shodan CLI\n"
	/usr/bin/python /usr/lib/python2.7/dist-packages/easy_install.py shodan
}

gitPull() {
	gitRepos=(
		https://github.com/BloodHoundAD/BloodHound.git,
		https://github.com/cobbr/Covenant.git,
		https://github.com/byt3bl33d3r/CrackMapExec.git,
		https://github.com/galkan/crowbar.git,
		https://github.com/g0tmi1k/debian-ssh.git,
		https://github.com/BC-SECURITY/Empire.git,
		https://github.com/Hackplayers/evil-winrm.git,
		https://github.com/OJ/gobuster.git,
		https://github.com/SecureAuthCorp/impacket.git,
		https://github.com/magnumripper/JohnTheRipper.git,
		https://github.com/04x/JoomBrute.git,
		https://github.com/bkimminich/juice-shop,
		https://github.com/ohpe/juicy-potato.git,
		https://github.com/rebootuser/LinEnum.git,
		https://github.com/mzet-/linux-exploit-suggester.git,
		https://github.com/sleventyeleven/linuxprivchecker.git,
		https://github.com/worawit/MS17-010.git,
		https://github.com/samratashok/nishang.git,
		https://github.com/PowerShellMafia/PowerSploit.git,
		https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git,
		https://github.com/DominicBreuker/pspy.git,
		https://github.com/SpiderLabs/Responder.git,
		https://github.com/Greenwolf/social_mapper.git,
		https://github.com/rapid7/ssh-badkeys.git,
		https://github.com/rasta-mouse/Watson.git,
		https://github.com/bitsadmin/wesng.git,
		https://github.com/n00py/WPForce.git
	)
	
	for repo in "${gitRepos[@]}"
	do
		echo "\n[*] Pulling: $repo";
		/usr/bin/sudo /usr/bin/git clone $repo /opt 2>&1/dev/null
		installSuccess $? $repo
	done

}

installSuccess() {
	if [ $1 -eq 0 ]; then
    		echo "\n[!] Install Successful: $2"
	else
    		echo "\n[X] Install Failed: $2"
	fi
}

main() {
	echo "System Update and Upgrade"
	/usr/bin/sudo apt update && sudo apt upgrade
	installSuccess $? "System Upgrades and Updates"
	
	echo "\n[*] Installing 'apt' Tools\n"
	aptInstall()

	echo "\n[*] Installing 'pip' Tools\n"
	pipInstall()
}

main()
