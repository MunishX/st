#!/bin/bash

## PHP 7.2 zts


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


#############################################

mkdir -p /home/admin/php-zts/
software_name="php-zts"
uname="admin"
admin_username="admin"

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/www -O /home/admin/php-zts/php-zts.conf
sed -i "s,^.*/run/php-fpm-pool.pid.*,pid = /home/admin/php-zts/php-zts.pid," /home/admin/php-zts/php-zts.conf
sed -i "s/^.*www-name.*/[$software_name]/" /home/admin/php-zts/php-zts.conf
sed -i "s/^.*user-name.*/user = $uname/" /home/admin/php-zts/php-zts.conf
sed -i "s/^.*group-name.*/group = $admin_username/" /home/admin/php-zts/php-zts.conf
sed -i "s,^.*/run/php-php-fpm.sock.*,listen = /home/admin/php-zts/php-zts.sock," /home/admin/php-zts/php-zts.conf
sed -i "s/^.*listen-u-name.*/listen.acl_users = $uname/" /home/admin/php-zts/php-zts.conf
sed -i "s,/user-php-root/,/home/admin/php-zts/,g" /home/admin/php-zts/php-zts.conf

sleep 5

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/phpintl -O /usr/lib/systemd/system/$software_name.service
sed -i "s,^.*php_config_file.conf.*,ExecStart=/usr/bin/php-fpm --fpm-config=$user_root/$mydom/$php_add_head/$software_name.conf --nodaemonize," /usr/lib/systemd/system/$software_name.service
chmod 777 /usr/lib/systemd/system/$software_name.service

