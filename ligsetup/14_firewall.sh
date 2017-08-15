#!/bin/bash

#service firewalld start
#service firewalld status
#sleep 5
#service firewalld restart
#service firewalld status
#sleep 5



firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-port=789/tcp  # Prutunel VPN
firewall-cmd --reload

## Add torrent leech range

sudo firewall-cmd --list-all


#systemctl mask firewalld
#systemctl stop firewalld
#systemctl disable firewalld

