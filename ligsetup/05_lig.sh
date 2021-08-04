#!/bin/bash

### install lighttpd

systemctl stop httpd.service
systemctl disable httpd.service
#yum -y remove httpd


#epel install

#yum -y install epel-release
#rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

cd /tmp
yum -y remove epel-release remi-release

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
yum -y install epel-release-latest-7.noarch.rpm
rpm --import /tmp/RPM-GPG-KEY-EPEL-7


yum -y update
yum -y install lighttpd lighttpd-fastcgi lighttpd-mod_geoip geoip

mkdir -p /etc/lighttpd/enabled/
#mkdir -p /home/lighttpd/{html,logs,bin}
mkdir -p /home/lighttpd/{tmp,bin}

#wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz -O /home/lighttpd/bin/GeoIP.dat.gz
#wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz -O /home/lighttpd/bin/GeoLiteCity.dat.gz
#gunzip /home/lighttpd/bin/GeoIP.dat.gz
#gunzip /home/lighttpd/bin/GeoLiteCity.dat.gz

#cd /home/lighttpd/bin/
#wget https://github.com/munishgaurav5/st/raw/master/GIP.rar
#unrar x GIP.rar
#rm -rf GIP.rar


chown -R lighttpd:lighttpd /home/lighttpd
chmod -R 777 /home/lighttpd

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

rm -rf /usr/lib/systemd/system/lighttpdo.service /etc/systemd/system/multi-user.target.wants/lighttpdo.service
mv  /usr/lib/systemd/system/lighttpd.service /usr/lib/systemd/system/lighttpdo.service
#mv /etc/systemd/system/multi-user.target.wants/lighttpd.service /etc/systemd/system/multi-user.target.wants/lighttpdo.service
#wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/ligintl -O /etc/systemd/system/multi-user.target.wants/lighttpd.service
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/ligintl -O /usr/lib/systemd/system/lighttpd.service
#chmod 777 /etc/systemd/system/multi-user.target.wants/lighttp*
chmod 777  /usr/lib/systemd/system/lighttpd*

systemctl daemon-reload

service lighttpd start
service lighttpd status
service lighttpd stop

echo ""
echo "Lighttpd Angel Configured.."
echo ""
#####################
