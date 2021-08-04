#!/bin/bash

## PHP 7.3
# add PHP 7 repo
##  /opt/remi/php73/root/usr/bin/phpize phpize
## /opt/remi/php73/root/usr/bin/phpize
## ./configure --with-php-config=/opt/remi/php73/root/usr/bin/php-config

## also update "PHP_V=" in create_vhosts.sh
PHP_V='php73'

#cd /tmp
#wget https://centos7.iuscommunity.org/ius-release.rpm
#wget https://repo.ius.io/ius-release-el7.rpm
#wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#rpm -ivh ius-release.rpm remi-release-7.rpm
#rpm -ivh ius-release-el7.rpm remi-release-7.rpm
#yum -y update

#https://blog.remirepo.net/post/2019/12/03/Install-PHP-7.4-on-CentOS-RHEL-or-Fedora
cd /tmp
yum remove -y epel-release remi-release
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
yum -y update

####

# PHP 7 Install
yum -y install epel-release

yum -y install ${PHP_V}-php-bcmath ${PHP_V}-php-mysql ${PHP_V}-php-devel ${PHP_V}-php-fpm ${PHP_V}-php-gd ${PHP_V}-php-intl ${PHP_V}-php-imap ${PHP_V}-php-mbstring ${PHP_V}-php-mcrypt ${PHP_V}-php-mysqlnd ${PHP_V}-php-opcache ${PHP_V}-php-pdo ${PHP_V}-php-pear ${PHP_V}-php-soap ${PHP_V}-php-xml ${PHP_V}-php-xmlrpc
yum -y install ${PHP_V}-php-pecl-uploadprogress ${PHP_V}-php-pecl-zip 

yum -y install ${PHP_V}-php-memcached ${PHP_V}-php-memcache ${PHP_V}-php-apcu* 
yum -y install zeromq zeromq-devel libevent libevent-devel 

yum -y update

## PHP-PHALCON 
#curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.rpm.sh | sudo bash
#yum -y install ${PHP_V}-php-phalcon 

## PHP-MongoDB 
#yum -y install ${PHP_V}-php-pecl-mongodb 

## PHP-REDIS
yum -y install ${PHP_V}-php-pecl-redis

## PHP-ZMQ
yum -y install ${PHP_V}-php-pecl-zmq

## PHP-LibEvent (PHP-libev)
yum -y install ${PHP_V}-php-pecl-event


## PHP-swoole (swoole/swoole-src)
yum -y install ${PHP_V}-php-pecl-swoole


## PHP FIX + DATE 
echo "cgi.fix_pathinfo=1" >> /etc/opt/remi/${PHP_V}/php.ini
echo "date.timezone = UTC" >> /etc/opt/remi/${PHP_V}/php.ini

## php7x to PHP link
ln -s /usr/bin/${PHP_V} /usr/bin/php
ln -s /opt/remi/${PHP_V}/root/usr/sbin/php-fpm /usr/bin/php-fpm
ln -s /opt/remi/${PHP_V}/root/usr/bin/phpize /usr/bin/phpize

## SWITCH OFF EXPOSE PHP
sed -i "s/^.*expose_php =.*/expose_php = Off/" /etc/opt/remi/${PHP_V}/php.ini
sed -i "s/^.*mail.add_x_header =.*/mail.add_x_header = Off/" /etc/opt/remi/${PHP_V}/php.ini
sed -i "s/^.*upload_max_filesize =.*/upload_max_filesize = 20M/" /etc/opt/remi/${PHP_V}/php.ini

####

### MEMCACHED CONFIG
yum -y install memcached redis

echo '
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="1024"
OPTIONS="-l 127.0.0.1"
' > /etc/sysconfig/memcached

#####

#### OPCACHE CONFIG
sed -i "s/^.*opcache.memory_consumption=.*/opcache.memory_consumption=999/" /etc/opt/remi/${PHP_V}/php.d/10-opcache.ini
sed -i "s/^.*opcache.max_accelerated_files=.*/opcache.max_accelerated_files=94000/" /etc/opt/remi/${PHP_V}/php.d/10-opcache.ini
####

