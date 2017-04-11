#!/bin/bash

##### MariaDB 10.1 config
echo "
# MariaDB 10.1 CentOS repository list - created 2016-12-24 04:21 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.1.22/yum/centos7-amd64
gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
gpgcheck=1
" > /etc/yum.repos.d/mariadb.repo


#### MariaDB install ####

mkdir -p /var/lib/mysql/

cd /tmp
yum -y install epel-release wget telnet 
yum -y update

yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
yum -y install ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel 

#systemctl start mysql
#systemctl enable mysql

systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb

# service mysql start
# chkconfig mysql on

sudo mv /etc/my.cnf /etc/my.cnf.bak
sudo cp /usr/share/mysql/my-huge.cnf /etc/my.cnf

systemctl restart mariadb
systemctl status mariadb



netstat -tap | grep mysql

sleep 10
#######
