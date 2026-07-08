#!/bin/bash

BASE_URL="https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/"
if [[ $1 = "" ]]; then 
   echo "using BASE_URL: ${BASE_URL}" 
else
   BASE_URL=$1
fi


# lighttpd config file test
# lighttpd -t -f /etc/lighttpd/lighttpd.conf
# lighttpd -tt -f /etc/lighttpd/lighttpd.conf

### install lighttpd

systemctl stop httpd.service
systemctl disable httpd.service
#yum -y remove httpd


#epel install

#yum -y install epel-release
#rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

cd /tmp
#yum -y remove epel-release remi-release
rm -rf epel-release* RPM-GPG-KEY-EPEL*

#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
#wget https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-10
#yum -y install epel-release-latest-10.noarch.rpm
#rpm --import /tmp/RPM-GPG-KEY-EPEL-10

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm

# or
# yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

yum -y update
yum -y install lighttpd lighttpd-fastcgi 
#yum -y install lighttpd-mod_geoip geoip

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
chmod -R 766 /home/lighttpd

#usermod -m -d /home/lighttpd lighttpd

systemctl stop lighttpd
#service lighttpd stop
usermod -m -d /home/lighttpd/ lighttpd
sudo usermod -a -G lighttpd lighttpd


#sleep 5
#umask 0002
#umask
# check errors at /var/log/lighttpd/error.log

####################
## Lighttpd Angel
#service lighttpd stop
systemctl stop lighttpd
systemctl disable lighttpd

rm -rf /usr/lib/systemd/system/lighttpdo.service 
mv  /usr/lib/systemd/system/lighttpd.service /usr/lib/systemd/system/lighttpdo.service
wget ${BASE_URL}replace/09_lig_ligintl -O /usr/lib/systemd/system/lighttpd.service
chmod 777  /usr/lib/systemd/system/lighttpd*

#rm -rf /etc/systemd/system/multi-user.target.wants/lighttpdo.service
#mv /etc/systemd/system/multi-user.target.wants/lighttpd.service /etc/systemd/system/multi-user.target.wants/lighttpdo.service
#wget ${BASE_URL}replace/ligintl -O /etc/systemd/system/multi-user.target.wants/lighttpd.service
#chmod 777 /etc/systemd/system/multi-user.target.wants/lighttp*


systemctl daemon-reload

#service lighttpd start
#service lighttpd status
#service lighttpd stop

systemctl start lighttpd
systemctl status lighttpd --no-pager
systemctl stop lighttpd


echo ""
echo "Lighttpd Angel Configured.."
echo ""

## install certbot - auto mode for lighttpd
#sudo dnf install epel-release -y
#sudo dnf install certbot -y

###systemctl start certbot-renew.timer
# /usr/lib/systemd/system/certbot-renew.timer



##################### REPLACE ########################

rm -rf /etc/lighttpd/*.old
rm -rf /etc/lighttpd/conf.d/*.old

mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.old
mv /etc/lighttpd/modules.conf /etc/lighttpd/modules.old
mv /etc/lighttpd/conf.d/fastcgi.conf /etc/lighttpd/conf.d/fastcgi.old
mv /etc/lighttpd/conf.d/cgi.conf /etc/lighttpd/conf.d/cgi.old
mv /etc/lighttpd/conf.d/access_log.conf /etc/lighttpd/conf.d/access_log.old
#mv /etc/lighttpd/conf.d/geoip.conf /etc/lighttpd/conf.d/geoip.old

#### LIGHTTPD CONFIG
wget ${BASE_URL}replace/09_replace_ligcnf -O /etc/lighttpd/lighttpd.conf

#### MODULES CONFIG
wget ${BASE_URL}replace/09_replace_modcnf -O /etc/lighttpd/modules.conf

#### FASTCGI CONFIG
wget ${BASE_URL}replace/09_replace_fgicnf -O /etc/lighttpd/conf.d/fastcgi.conf

#### CGI CONFIG
wget ${BASE_URL}replace/09_replace_cgi -O /etc/lighttpd/conf.d/cgi.conf

#### ACCESS_LOG CONFIG
wget ${BASE_URL}replace/09_replace_alog -O /etc/lighttpd/conf.d/access_log.conf

#### GEO_IP CONFIG
#wget ${BASE_URL}replace/09_replace_gip -O /etc/lighttpd/conf.d/geoip.conf
