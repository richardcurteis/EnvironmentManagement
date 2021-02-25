#!/bin/bash

aptInstall() {
        aptApps=( neo4j powershell-empire starkiller chromium-browser flameshot nodejs unattended-upgrades libpam-pwquality python3-pip curl default-jre openjdk-11-jre-headless openjdk-8-jre-headless golang-go gccgo-go ruby php7.2-cli hhvm )
        for app in "${aptApps[@]}"
        do
                echo "[*] Installing: $app";
                /usr/bin/sudo /usr/bin/apt install $app -y 2> /dev/null 
                installSuccess $? $app
        done
}

pipInstall() {
        pipApps=( setuptools sslyze scapy flask flake8  )
        for app in "${pipApps[@]}"
        do
                echo "[*] Installing: $app";
                /usr/bin/pip3 install $app 2> /dev/null
                installSuccess $? $app
        done
}

gitPull() {
	mkdir ~/repos
        gitRepos=(
                https://github.com/BloodHoundAD/BloodHound.git
                "--recurse-submodules https://github.com/cobbr/Covenant.git -b dev"
                https://github.com/galkan/crowbar.git
                https://github.com/g0tmi1k/debian-ssh.git
                https://github.com/Hackplayers/evil-winrm.git
                https://github.com/SecureAuthCorp/impacket.git
                https://github.com/magnumripper/JohnTheRipper.git
                https://github.com/04x/JoomBrute.git
                https://github.com/ohpe/juicy-potato.git
                https://github.com/rebootuser/LinEnum.git
                https://github.com/mzet-/linux-exploit-suggester.git
                https://github.com/sleventyeleven/linuxprivchecker.git
                https://github.com/samratashok/nishang.git
                https://github.com/PowerShellMafia/PowerSploit.git
                https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
                https://github.com/DominicBreuker/pspy.git
                https://github.com/SpiderLabs/Responder.git
                https://github.com/rapid7/ssh-badkeys.git
                https://github.com/rasta-mouse/Watson.git
                https://github.com/bitsadmin/wesng.git
                https://github.com/n00py/WPForce.git
        )
        cd ~/repos
        for repo in "${gitRepos[@]}"
        do
                echo "[*] Clone: $repo";
                /usr/bin/sudo /usr/bin/git clone $repo 2> /dev/null
                installSuccess $? $repo
        done
        cd ~
}

setupDotNetCore() {
        clearOldInstall dotnet
        version="dotnet-sdk-5.0.103-linux-x64"
        echo ">> Setting up .NET Core SDK: $version"
	cd ~/Downloads
        /usr/bin/wget https://download.visualstudio.microsoft.com/download/pr/a2052604-de46-4cd4-8256-9bc222537d32/a798771950904eaf91c0c37c58f516e1/$version.tar.gz
        /usr/bin/gunzip $version.tar.gz
        /usr/bin/mkdir dotnet
        /usr/bin/mv $version.tar ./dotnet
        cd ./dotnet
        /usr/bin/tar xvf $version.tar
        sudo /usr/bin/mkdir /opt/dotnet
        rm $version.tar
        sudo /usr/bin/mv * /opt/dotnet
        sudo ln -s /opt/dotnet/dotnet /usr/bin/dotnet
        cd ../
        rm -rf ./dotnet
}

setupBloodhound() {
        clearOldInstall bloodhound
        version="4.0.2"
	cd ~/Downloads
	echo ">> Setting up BloodHound"
	wget https://github.com/BloodHoundAD/BloodHound/releases/download/$version/BloodHound-linux-x64.zip
	unzip ./BloodHound-linux-x64.zip
	sudo mv  ./BloodHound-linux-x64 /opt/bloodhound
	sudo ln -s /opt/bloodhound/BloodHound /usr/bin/bloodhound
}

setupGobuster() {
        clearOldInstall gobuster
        version="v3.1.0"
	echo ">> Setting up Gobuster"
	wget https://github.com/OJ/gobuster/releases/download/$version/gobuster-linux-amd64.7z
	7z x ./gobuster-linux-amd64.7z
	sudo mv ./gobuster-linux-amd64 /opt/gobuster
	chmod +x /opt/gobuster-linux-amd64
	rm ./gobuster-linux-amd64.7z
	sudo ln -s /opt/gobuster/gobuster /usr/bin/gobuster
}

setupCrackMapExec() {
        clearOldInstall cme
	echo ">> Setting up CME"
        version="v5.1.1dev"
	wget https://github.com/byt3bl33d3r/CrackMapExec/releases/download/$version/cme-ubuntu-latest.4.zip
	unzip ./cme-ubuntu-latest.4.zip
	rm ./cme-ubuntu-latest.4.zip
	sudo mv ./cme /opt
	chmod +x /opt/cme
	sudo ln -s /opt/cme /usr/bin/cme
}

setupAquatone() {
        clearOldInstall aquatone
	echo ">> Setting up Aquatone"
        version="1.7.0"
	wget https://github.com/michenriksen/aquatone/releases/download/v$version/aquatone_macos_amd64_$version.zip
	unzip ./aquatone_macos_amd64_$version.zip
	rm ./aquatone_macos_amd64_$version.zip
        sudo mv ./aquatone /opt
        chmod +x /opt/aquatone
        sudo ln -s /opt/aquatone /usr/bin/aquatone
}

setupCodium() {
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
	echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
	sudo apt update && sudo apt install codium
}

clearOldInstall() {
        # Remove old binaries
        if [ -d /opt/$1 ] ;then sudo rm -rf /opt/$1 ; fi
        # Remove old symlinks
        if [ -f /usr/bin/$1 ] ; then sudo rm /usr/share/$1 ; fi
}

installSuccess() {
        if [ $1 -eq 0 ]; then echo ; else echo "[X] Install Failed: $2" ; fi
}

main() {
        echo "System Update and Upgrade"
        /usr/bin/sudo apt-get update && sudo apt-get upgrade
        installSuccess $? "System Upgrades and Updates"

        echo "[*] Installing 'apt' Tools"
        aptInstall
	setupDotNetCore
	setupGobuster
	setupBloodhound
	setupCrackMapExec
	setupAquatone
	setupCodium
        echo "[*] Installing 'pip' Tools"
        pipInstall
        gitPull
}

main
# Remove kali welcome message
touch ~/.hushlogin 

# Fix recent issues with plasma
sudo apt-get install sddm-theme-breeze
sudo apt-get --reinstall plasma-desktop
