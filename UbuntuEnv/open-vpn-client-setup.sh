#!/bin/bash

# Run on dropbox client

apt-get udate && apt-get upgrade -y
apt install openvpn -y
cp $0 /etc/openvpn/openvpn.conf
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
apt install xrdp -y
service xrdp start
service xrdp-sesman start
systemctl enable xrdp
