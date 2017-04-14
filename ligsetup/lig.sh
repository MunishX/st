#!/bin/bash

### install lighttpd

systemctl stop httpd.service
systemctl disable httpd.service
yum -y remove httpd



yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum -y update
yum -y install lighttpd
yum -y install lighttpd-fastcgi

mkdir -p /etc/lighttpd/enabled/
#mkdir -p /home/lighttpd/{html,logs,bin}
mkdir -p /home/logs/

mkdir -p /home/admin/ip/html

chown -R lighttpd:lighttpd /home/logs
chmod -R 777 /home/logs
#usermod -m -d /home/lighttpd lighttpd

service lighttpd stop
usermod -m -d /home/logs lighttpd

sleep 5
umask 0002
umask
# check errors at /var/log/lighttpd/error.log
