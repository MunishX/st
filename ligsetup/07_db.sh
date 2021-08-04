#!/bin/bash

# UPGRADE NOTE
# After upgrading MariaDB run:
# mysql_upgrade -u root -p


##### add MariaDB 10.3.5 repo stable from mariadb
# http://yum.mariadb.org/10.3.5/centos74-amd64/rpms/MariaDB-10.3.5-centos74-x86_64-server.rpm
#echo "
#
# MariaDB 10.3.5 CentOS repository list - created 2018-02-26 05:13 UTC
# http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://yum.mariadb.org/10.3.5/centos7-amd64
#gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
#gpgcheck=1
#
#" > /etc/yum.repos.d/mariadb.repo
#####

##### add MariaDB 10.3.8 repo stable from mariadb
# http://yum.mariadb.org/10.3.5/centos74-amd64/rpms/MariaDB-10.3.5-centos74-x86_64-server.rpm
#echo "

# MariaDB 10.3 CentOS repository list - created 2018-07-15 19:14 UTC
# http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.3.8/yum/centos7-amd64
#gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
#gpgcheck=1

#" > /etc/yum.repos.d/mariadb.repo
#####

##### add MariaDB mariadb-10.3.13 repo stable from mariadb
# http://yum.mariadb.org/mariadb-10.3.13/centos74-amd64/rpms/MariaDB-mariadb-10.3.13-centos74-x86_64-server.rpm
#echo "
# MariaDB 10.3 CentOS repository list - created 2019-03-22 19:14 UTC
# http://downloads.mariadb.org/mariadb/repositories/
#[mariadb]
#name = MariaDB
#baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.3.13/yum/centos7-amd64
#gpgkey=http://ftp.hosteurope.de/mirror/archive.mariadb.org/PublicKey
#gpgcheck=1
#" > /etc/yum.repos.d/mariadb.repo
#####

##### add MariaDB mariadb-10.6.3 repo stable from mariadb
# http://yum.mariadb.org/mariadb-10.6.3/centos74-amd64/rpms/MariaDB-mariadb-10.3.13-centos74-x86_64-server.rpm
echo "

# MariaDB 10.6.3 CentOS repository list - created 2021
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.6.3/yum/centos7-amd64/
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
