#!/bin/bash


#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --permanent --zone=public --add-port=789/tcp  # Prutunel VPN
#firewall-cmd --reload



#systemctl mask firewalld
#systemctl stop firewalld
#systemctl disable firewalld

service iptables stop
service firewalld stop

chkconfig iptables off
chkconfig firewalld off
