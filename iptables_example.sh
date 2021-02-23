#!/bin/bash

if [ -z $1 ]
then
  echo "[!] Missing whitelist address. Make sure this is supplied to make sure you don't get locked out"
  exit 1
fi

# Flush tables
iptables -F
ip6tables -F

# Whitelist my address 
iptables -I INPUT -s $1 -j ACCEPT

# Set a default policy of DROP
iptables -P INPUT DROP [0:0]
iptables -P FORWARD DROP [0:0]
iptables -P OUTPUT DROP [0:0]

# Accept any related or established connections
iptables -I INPUT  1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I OUTPUT 1 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow all traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow outbound DHCP request
iptables -A OUTPUT –o eth0 -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# Allow inbound SSH
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW  -j ACCEPT

# Allow inbound HTTPS
iptables -A INPUT -i eth0 -p tcp -m tcp --dport 443 -m state --state NEW  -j ACCEPT

# Allow outbound email
#-A OUTPUT -i eth0 -p tcp -m tcp --dport 25 -m state --state NEW  -j ACCEPT

# Outbound DNS lookups
iptables -A OUTPUT -o eth0 -p udp -m udp --dport 53 -j ACCEPT

# Outbound PING requests
iptables -A OUTPUT –o eth0 -p icmp -j ACCEPT

# Outbound Network Time Protocol (NTP) requests
iptables -A OUTPUT –o eth0 -p udp --dport 123 --sport 123 -j ACCEPT

# Outbound HTTP
#-A OUTPUT -o eth0 -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT
#-A OUTPUT -o eth0 -p tcp -m tcp --dport 443 -m state --state NEW -j ACCEPT

#### IPv6 Rules
# Drop all IPv6
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

# Must allow loopback interface
ip6tables -A INPUT -i lo -j ACCEPT

# Reject connection attempts not initiated from the host
ip6tables -A INPUT -p tcp --syn -j DROP

# Allow return connections initiated from the host
ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
