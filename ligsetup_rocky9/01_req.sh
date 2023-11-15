#!/bin/bash

# cd /tmp && yum install wget -y && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/01_req.sh && chmod 777 01_req.sh && ./01_req.sh 

############## Req Install Start #############
cd /tmp

iptables -F
service iptables stop
chkconfig iptables off

yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip epel-release git sudo make cmake sed at ant iotop hdparm 
#yum -y install rar unrar lsblk awk GeoIP

yum -y update

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel libart_lgpl-devel gperftools-devel libicu libicu-devel gmp-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant pam-devel git perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils numactl lsof pkgconfig tk-devel 
#yum -y install mailx libgcj GeoIP-devel aspell aspell-devel enchant-devel perl-ExtUtils libc-client libc-client-devel gdbm-devel bluez-libs-devel

sudo yum -y install unzip zip unrar rsync psmisc mediainfo iftop 
#yum -y install rar syslog-ng-libdbi help2man
########## RAR #############
echo ""
echo "Installing latest RAR..."
cd /tmp
#wget https://www.rarlab.com/rar/rarlinux-x64-6.0.2.tar.gz
wget https://www.rarlab.com/rar/rarlinux-x64-624.tar.gz
tar xzf rarlinux-x64-*.tar.gz
cd rar*/
make
wget -O /etc/rarreg.key https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/rarreg.key
cd ..
rm -rf rar*

############# SQLITE3 ######################
mv /usr/local/bin/sqlite3 /usr/local/bin/sqlite3_old

cd /tmp
#wget https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz
wget https://www.sqlite.org/2023/sqlite-autoconf-3440000.tar.gz
tar -xf sqlite*.tar.gz
cd sqlite*/
CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1" ./configure
make
make install

sqlite3 --version

cd ..
rm -rf sqlite*

############################################

########
## CROND : cronie
echo ""
echo "Installing crond/cronie..."
sudo yum -y install cronie
sudo systemctl status crond.service

########
## UMASK
echo ""
echo " Fixing UMASK for all user..."
sleep 3
sed -i "s,^.*umask 0.*,umask 002,g" /etc/bashrc

# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/req.sh && chmod 777 req.sh && ./req.sh

## Firewalld
yum install firewalld -y

systemctl enable firewalld
systemctl start firewalld
systemctl status firewalld
sudo firewall-cmd --list-all
sleep 5
systemctl restart firewalld
systemctl status firewalld
sudo firewall-cmd --list-all
sleep 5

#firewall-cmd --permanent --zone=public --remove-service=http

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
firewall-cmd --list-all
sleep 5

#service firewalld start
#service firewalld status
#sleep 5
#service firewalld restart
#service firewalld status
#sleep 5
