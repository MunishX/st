#!/bin/bash

## PHP 7.1
# add PHP 7 repo
cd /tmp
wget https://centos7.iuscommunity.org/ius-release.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh ius-release.rpm remi-release-7.rpm
yum -y update

####

# PHP 7 Install
yum -y install php71-php-bcmath php71-php-mysql php71-php-devel php71-php-fpm php71-php-gd php71-php-intl php71-php-imap php71-php-mbstring php71-php-mcrypt php71-php-mysqlnd php71-php-opcache php71-php-pdo php71-php-pear php71-php-soap php71-php-xml php71-php-xmlrpc
yum -y install php71-php-pecl-uploadprogress php71-php-pecl-zip 
yum -y install php71-php-memcached php71-php-memcache php71-php-apcu*
yum -y install libevent libevent-devel
yum -y update

## PHP-PHALCON + PHP-MongoDB
curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.rpm.sh | sudo bash
yum -y install php71-php-phalcon php71-php-pecl-mongodb php71-php-pecl-redis

## PHP FIX + DATE 
echo "cgi.fix_pathinfo=1" >> /etc/opt/remi/php71/php.ini
echo "date.timezone = UTC" >> /etc/opt/remi/php71/php.ini

## php71 to PHP link
ln -s /usr/bin/php71 /usr/bin/php
ln -s /opt/remi/php71/root/usr/sbin/php-fpm /usr/bin/php-fpm

## SWITCH OFF EXPOSE PHP
sed -i "s/^.*expose_php =.*/expose_php = Off/" /etc/opt/remi/php71/php.ini
sed -i "s/^.*upload_max_filesize =.*/upload_max_filesize = 20M/" /etc/opt/remi/php71/php.ini

####

### MEMCACHED CONFIG
yum -y install memcached redis

echo '
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="1024"
OPTIONS="localhost"
' > /etc/sysconfig/memcached

#####

#### OPCACHE CONFIG
sed -i "s/^.*opcache.memory_consumption=.*/opcache.memory_consumption=999/" /etc/opt/remi/php71/php.d/10-opcache.ini
sed -i "s/^.*opcache.max_accelerated_files=.*/opcache.max_accelerated_files=94000/" /etc/opt/remi/php71/php.d/10-opcache.ini
####

