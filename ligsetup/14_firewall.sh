#!/bin/bash

#tcptunnel --local-port=400 --remote-port=3389 --remote-host=88.198.69.240 --fork

#firewall-cmd --permanent --zone=public --add-port=789/tcp
#firewall-cmd --add-forward-port=port=4444:proto=tcp:toport=3389:toaddr=IP_OF_RDP_SERVER --permanent
#firewall-cmd --reload

#service firewalld start
#service firewalld status
#sleep 5
#service firewalld restart
#service firewalld status
#sleep 5

#########################################
#firewall-cmd --permanent --zone=public --add-port=25/tcp   # For MailServer
#firewall-cmd --permanent --zone=public --add-port=110/tcp  # For MailServer
#firewall-cmd --permanent --zone=public --add-port=143/tcp  # For MailServer
#firewall-cmd --permanent --zone=public --add-port=465/tcp  # For MailServer
#firewall-cmd --permanent --zone=public --add-port=587/tcp  # For MailServer
#firewall-cmd --permanent --zone=public --add-port=993/tcp  # For MailServer
#firewall-cmd --permanent --zone=public --add-port=995/tcp  # For MailServer

#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --add-service=ntp --permanent 


#firewall-cmd --permanent --zone=public --add-port=49152-65535/udp  # transmission use these udp ports
#firewall-cmd --permanent --zone=public --add-port=49152-65535/tcp  # transmission use these udp ports
#firewall-cmd --permanent --zone=public --add-port=9061/tcp  # For Transmission webui

#firewall-cmd --reload 

#firewall-cmd --permanent --zone=public --remove-port=10050/tcp
################################################

#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https

#firewall-cmd --permanent --zone=public --add-port=789/tcp  # Prutunel VPN

#firewall-cmd --permanent --zone=public --add-port=49152-65535/udp  # transmission use these udp ports
#firewall-cmd --permanent --zone=public --add-port=49152-65535/tcp  # transmission use these udp ports
#firewall-cmd --permanent --zone=public --add-port=9060/tcp  # For Transmission webui

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

##light config tests
#lighttpd -p -f /etc/lighttpd/lighttpd.conf
#lighttpd -t -f /etc/lighttpd/lighttpd.conf
#lighttpd -tt -f /etc/lighttpd/lighttpd.conf

