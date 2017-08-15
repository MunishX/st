#!/bin/bash

# cd /tmp && yum install wget -y && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/01_req.sh && chmod 777 01_req.sh && ./01_req.sh 

############## Req Install Start #############
cd /tmp

iptables -F
service iptables stop
chkconfig iptables off

yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar epel-release git sudo make cmake GeoIP sed at ant iotop iftop hdparm lsblk

yum -y update

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel mailx expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel libgcj gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel libart_lgpl-devel  GeoIP-devel gperftools-devel libicu libicu-devel aspell gmp-devel aspell-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant enchant-devel pam-devel git perl-ExtUtils perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils libc-client libc-client-devel numactl lsof pkgconfig gdbm-devel tk-devel bluez-libs-devel
sudo yum -y install unzip zip rar unrar rsync psmisc syslog-ng-libdbi mediainfo


### RAR
cd /tmp
wget http://www.rarlab.com/rar/rarlinux-x64-5.4.0.tar.gz
tar xzf rarlinux-x64-*.tar.gz
cd rar
make
cd ..
rm -rf rar*

########
## UMASK
echo ""
echo " Fixing UMASK for all user..."
sleep 3
sed -i "s,^.*umask 0.*,umask 002,g" /etc/bashrc

# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/req.sh && chmod 777 req.sh && ./req.sh
