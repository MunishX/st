#!/bin/bash

# add PHP 7 repo
cd /tmp
wget https://centos6.iuscommunity.org/ius-release.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh ius-release.rpm remi-release-6.rpm
yum -y update

####

# PHP 7 Install
yum -y install php70-php-bcmath php70-php-mysql php70-php-devel php70-php-fpm php70-php-gd php70-php-intl php70-php-imap php70-php-mbstring php70-php-mcrypt php70-php-mysqlnd php70-php-opcache php70-php-pdo php70-php-pear php70-php-soap php70-php-xml php70-php-xmlrpc
yum -y install php70-php-pecl-uploadprogress php70-php-pecl-zip
yum -y install php70-php-memcached php70-php-memcache php70-php-apcu* memcached
yum -y install libevent libevent-devel
yum -y update

echo "cgi.fix_pathinfo=1" >> /etc/opt/remi/php70/php.ini
echo "date.timezone = UTC" >> /etc/opt/remi/php70/php.ini

ln -s /usr/bin/php70 /usr/bin/php
ln -s /opt/remi/php70/root/usr/sbin/php-fpm /usr/bin/php-fpm

sed -i "s/^.*expose_php =.*/expose_php = Off/" /etc/opt/remi/php70/php.ini

####

### MEMCACHED CONFIG
yum -y install memcached

echo '
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="1024"
OPTIONS="localhost"
' > /etc/sysconfig/memcached

#####

#### OPCACHE CONFIG
sed -i "s/^.*opcache.memory_consumption=.*/opcache.memory_consumption=999/" /etc/opt/remi/php70/php.d/10-opcache.ini
sed -i "s/^.*opcache.max_accelerated_files=.*/opcache.max_accelerated_files=94000/" /etc/opt/remi/php70/php.d/10-opcache.ini
####

