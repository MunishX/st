#!/bin/bash


#php 7
cd /tmp
wget https://centos7.iuscommunity.org/ius-release.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh ius-release.rpm remi-release-7.rpm
yum -y update


# PHP 7
yum -y install php70-php-bcmath php70-php-mysql php70-php-devel php70-php-fpm php70-php-gd php70-php-intl php70-php-imap php70-php-mbstring php70-php-mcrypt php70-php-mysqlnd php70-php-opcache php70-php-pdo php70-php-pear php70-php-soap php70-php-xml php70-php-xmlrpc
yum -y install php70-php-pecl-uploadprogress php70-php-pecl-zip
yum -y install php70-php-memcached php70-php-memcache php70-php-apcu* memcached
yum -y install libevent libevent-devel
yum -y update
#mkdir -p /run/memcached/
#chown -R memcached:memcached /run/memcached/

#### /// nano /etc/opt/remi/php70/php-fpm.d/www.conf
#### /// update
#### /// listen = 127.0.0.1:9007

echo "cgi.fix_pathinfo=1" >> /etc/opt/remi/php70/php.ini
echo "date.timezone = UTC" >> /etc/opt/remi/php70/php.ini

ln -s /usr/bin/php70 /usr/bin/php
ln -s /opt/remi/php70/root/usr/sbin/php-fpm /usr/bin/php-fpm

