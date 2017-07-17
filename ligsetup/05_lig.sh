#!/bin/bash

### install lighttpd

systemctl stop httpd.service
systemctl disable httpd.service
#yum -y remove httpd



yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum -y update
yum -y install lighttpd lighttpd-fastcgi

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

####################
## Lighttpd Angel
service lighttpd stop

mv /etc/systemd/system/multi-user.target.wants/lighttpd.service /etc/systemd/system/multi-user.target.wants/lighttpdo.service
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/ligintl -O /etc/systemd/system/multi-user.target.wants/lighttpd.service
chmod 777 /etc/systemd/system/multi-user.target.wants/lighttp*

systemctl daemon-reload

service lighttpd start
service lighttpd status
service lighttpd stop

echo ""
echo "Lighttpd Angel Configured.."
echo ""
#####################
