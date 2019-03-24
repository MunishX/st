#!/bin/bash

## PHP 7.2
# add PHP 7 repo

PHP_V='php72'

cd /tmp
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -ivh epel-release-latest-7.noarch.rpm webtatic-release.rpm
yum -y update

####

# PHP 7 Install
yum -y install libevent libevent-devel
yum -y install php72w* --exclude=php72w-mysql --exclude=php72w-pecl-mongodb
yum -y update


## PHP FIX + DATE 
echo "cgi.fix_pathinfo=1" >> /etc/php.ini
echo "date.timezone = UTC" >> /etc/php.ini


## php7x to PHP link
#ln -s /usr/bin/${PHP_V} /usr/bin/php
ln -s /usr/sbin/php-fpm /usr/bin/php-fpm

## SWITCH OFF EXPOSE PHP
sed -i "s/^.*expose_php =.*/expose_php = Off/" /etc/php.ini
sed -i "s/^.*mail.add_x_header =.*/mail.add_x_header = Off/" /etc/php.ini
sed -i "s/^.*upload_max_filesize =.*/upload_max_filesize = 20M/" /etc/php.ini

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
sed -i "s/^.*opcache.memory_consumption=.*/opcache.memory_consumption=999/" /etc/php.d/opcache.ini
sed -i "s/^.*opcache.max_accelerated_files=.*/opcache.max_accelerated_files=94000/" /etc/php.d/opcache.ini

sed -i "s/^.*opcache.memory_consumption=.*/opcache.memory_consumption=999/" /etc/php-zts.d/opcache.ini
sed -i "s/^.*opcache.max_accelerated_files=.*/opcache.max_accelerated_files=94000/" /etc/php-zts.d/opcache.ini
####


cd /tmp
rm -rf pthreads*
wget -O pthreads.zip https://github.com/krakjoe/pthreads/archive/v3.2.0.zip
unzip pthreads.zip
rm -rf pthreads.zip
cd pthreads*/
zts-phpize
./configure --with-php-config=/usr/bin/zts-php-config
make

cp modules/pthreads.so /usr/lib64/php-zts/modules/.
echo 'extension=pthreads.so' > /etc/php-zts.d/pthreads.ini

zts-php -i | grep -i thread

# /usr/bin/zts-php
# /usr/bin/php
# /usr/bin/php-fpm

# /usr/sbin/php-fpm

