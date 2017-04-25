#!/bin/bash

### install lighttpd

service httpd stop
chkconfig httpd off
#service httpd disable 
#yum -y remove httpd



yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum -y update
yum -y install lighttpd
yum -y install lighttpd-fastcgi

mkdir -p /etc/lighttpd/enabled/
#mkdir -p /home/lighttpd/{html,logs,bin}
mkdir -p /home/lighttpd/

chown -R lighttpd:lighttpd /home/lighttpd
chmod -R 777 /home/lighttpd/

#usermod -m -d /home/lighttpd lighttpd

service lighttpd stop
usermod -m -d /home/lighttpd/ lighttpd
sudo usermod -a -G lighttpd lighttpd


#sleep 5
#umask 0002
#umask
# check errors at /var/log/lighttpd/error.log
