#!/bin/bash

##### add MariaDB 10.1 repo
#echo "
## MariaDB 10.1 CentOS repository list - created 2016-12-24 04:21 UTC
## http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.1.22/yum/centos7-amd64
#gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
#gpgcheck=1

##### add MariaDB 10.2 repo
#echo "
## MariaDB 10.2 CentOS repository list - created 2017-06-28 12:44 UTC
## http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.2.6/yum/centos7-amd64
#gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
#gpgcheck=1

##### add MariaDB 10.2 repo stable from mariadb
#echo "
#
## MariaDB 10.2 CentOS repository list - created 2017-12-25 05:13 UTC
## http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://yum.mariadb.org/10.2/centos7-amd64
#gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
#gpgcheck=1
#
#" > /etc/yum.repos.d/mariadb.repo
######

##### add MariaDB 10.3.5 repo stable from mariadb
# http://yum.mariadb.org/10.3.5/centos74-amd64/rpms/MariaDB-10.3.5-centos74-x86_64-server.rpm
echo "

# MariaDB 10.3.5 CentOS repository list - created 2018-02-26 05:13 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3.5/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
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

systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb

# service mysql start
# chkconfig mysql on

sudo mv /etc/my.cnf /etc/my.cnf.bak
sudo cp /usr/share/mysql/my-huge.cnf /etc/my.cnf

### IMGMAGIX FIX
sed -i 's,^.*<policy domain="coder" rights="none" pattern="HTTPS".*, <!--- <policy domain="coder" rights="none" pattern="HTTPS" />,' /etc/ImageMagick/policy.xml
sed -i 's,^.*<policy domain="coder" rights="none" pattern="URL".*, ---> <policy domain="coder" rights="none" pattern="URL" />,' /etc/ImageMagick/policy.xml
###

systemctl restart mariadb
systemctl status mariadb

netstat -tap | grep mysql

## Not compulsary
touch /var/lib/mysql/mysqld.log
chown -R mysql:mysql /var/lib/mysql/mysqld.log
chmod 700 /var/lib/mysql/mysqld.log
#######
