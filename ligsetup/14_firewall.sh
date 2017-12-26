#!/bin/bash

#service firewalld start
#service firewalld status
#sleep 5
#service firewalld restart
#service firewalld status
#sleep 5



#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https

firewall-cmd --permanent --zone=public --add-port=789/tcp  # Prutunel VPN

firewall-cmd --permanent --zone=public --add-port=49152-65535/udp  # transmission use these udp ports
firewall-cmd --permanent --zone=public --add-port=49152-65535/tcp  # transmission use these udp ports
firewall-cmd --permanent --zone=public --add-port=9060/tcp  # For Transmission webui

#firewall-cmd --permanent --zone=public --add-service=mysql   # use only if mysql is required to be accessed by other hosts

firewall-cmd --reload

## Add torrent leech range

sudo firewall-cmd --list-all


#systemctl mask firewalld
#systemctl stop firewalld
#systemctl disable firewalld

#ping off
sysctl -w net.ipv4.icmp_echo_ignore_all=1

#ping on
#sysctl -w net.ipv4.icmp_echo_ignore_all=0
