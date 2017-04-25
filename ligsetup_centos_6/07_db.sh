#!/bin/bash

##### add MariaDB 10.1 repo
echo "
# MariaDB 10.1 CentOS repository list - created 2016-12-24 04:21 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.1.22/yum/centos6-amd64
gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
gpgcheck=1
" > /etc/yum.repos.d/mariadb.repo
#####


#### MariaDB install ####

mkdir -p /var/lib/mysql/

cd /tmp
yum -y install epel-release wget telnet 
yum -y update

yum -y install MariaDB-client MariaDB-common MariaDB-compat MariaDB-devel MariaDB-server MariaDB-shared perl-DBD-MySQL
yum -y install ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel 

#systemctl start mysql
#systemctl enable mysql

service mysql start 
chkconfig mysql on
service mysql status 

# service mysql start
# chkconfig mysql on

sudo mv /etc/my.cnf /etc/my.cnf.bak
sudo cp /usr/share/mysql/my-huge.cnf /etc/my.cnf

### IMGMAGIX FIX
sed -i 's,^.*<policy domain="coder" rights="none" pattern="HTTPS".*, <!--- <policy domain="coder" rights="none" pattern="HTTPS" />,' /etc/ImageMagick/policy.xml
sed -i 's,^.*<policy domain="coder" rights="none" pattern="URL".*, ---> <policy domain="coder" rights="none" pattern="URL" />,' /etc/ImageMagick/policy.xml
###

service mysql restart 
service mysql status 


netstat -tap | grep mysql

#######
