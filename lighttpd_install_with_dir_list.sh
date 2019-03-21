#!/usr/bin/env bash

#lighttpd install

yum -y install epel-release
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
yum -y update

yum -y install lighttpd lighttpd-fastcgi lighttpd-mod_geoip sed

#sed -i "s/Listen 0.0.0.0:80/Listen 0.0.0.0:81/g" /etc/httpd/conf/httpd.conf
#sed -i "s/:80/:81/g" /etc/httpd/conf.modules.d/10-vhost.conf
sed -i "s/server.use-ipv6 = \"enable\"/server.use-ipv6 = \"disable\"/g" /etc/lighttpd/lighttpd.conf
echo "" >> /etc/lighttpd/lighttpd.conf
echo 'server.dir-listing = "enable"' >> /etc/lighttpd/lighttpd.conf
echo '' >> /etc/lighttpd/lighttpd.conf

systemctl enable  lighttpd.service
systemctl start  lighttpd.service
systemctl status  lighttpd.service

rm -rf /var/www/lighttpd/*
chown -R lighttpd:lighttpd /var/www/lighttpd



################################################

#firewall-cmd --permanent --zone=public --remove-port=10050/tcp
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --permanent --zone=public --add-port=789/tcp  # Prutunel VPN

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
firewall-cmd --list-all

sysctl -w net.ipv4.icmp_echo_ignore_all=1

#################################################
echo ""
echo "############ FINISHED ################"
echo ""
echo "USER =  lighttpd - chown -R lighttpd:lighttpd /var/www/lighttpd/*"
echo "HTML_DIR =  /var/www/lighttpd "
echo ""


