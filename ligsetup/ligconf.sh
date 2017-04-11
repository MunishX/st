#!/bin/bash

chown -R lighttpd:lighttpd /var/opt/remi/php70

## TIME UTC 

 timedatectl  status
 timedatectl set-timezone UTC
 timedatectl  status
# date -s '2017-04-02 20:43:30'

## sudo apt install -y ntp
#yum -y install ntp   
#systemctl start ntpd
#systemctl enable ntpd

## for centos 7 time updator
#yum install -y chrony
#systemctl enable chronyd
#systemctl start chronyd

##
#timedatectl set-local-rtc 0
