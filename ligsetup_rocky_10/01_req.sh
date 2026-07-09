#!/bin/bash

# cd /tmp && yum install wget -y && wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/01_req.sh && chmod 777 01_req.sh && ./01_req.sh 

NETWORK_INTERFACE_NAME="$(ip -o -4 route show to default | awk '{print $5}' | head -1)"
if [[ $1 = "" ]]; then 
   echo "using default NETWORK_INTERFACE_NAME: ${NETWORK_INTERFACE_NAME}" 
else
   NETWORK_INTERFACE_NAME=$1
fi

Setup_IPv6=n
if [[ $2 = "y" ]]; then 
   Setup_IPv6=$2
   echo "ipv6 enabled, updating ipv6 DNS in device: ${NETWORK_INTERFACE_NAME}" 
else
   echo "ipv6 disabled, not updating ipv6 DNS in device: ${NETWORK_INTERFACE_NAME}" 
fi


BASE_URL="https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/"
if [[ $3 = "" ]]; then 
   echo "using default BASE_URL: ${BASE_URL}" 
else
   BASE_URL=$3
fi

############## Req Install Start #############
cd /tmp

iptables -F
service iptables stop
chkconfig iptables off

# prefer ipv4 over ipv6
sudo echo 'precedence ::ffff:0:0/96 100' > /etc/gai.conf

yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip epel-release git sudo make cmake sed at ant iotop hdparm nmcli libatomic

sudo nmcli dev modify "$NETWORK_INTERFACE_NAME" ipv4.dns "8.8.8.8 8.8.4.4"
if [[ $Setup_IPV6 = 'y' ]]; then
sudo nmcli dev modify "$NETWORK_INTERFACE_NAME" ipv6.dns "2001:4860:4860::8888 2001:4860:4860::8844"
fi
sudo nmcli dev up "$NETWORK_INTERFACE_NAME"

yum -y update

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ zlib zlib-devel expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel gperftools-devel libicu libicu-devel gmp-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant pam-devel git perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils numactl lsof pkgconfig tk-devel 

# for upto Rocky 9 only (removed since Rocky 10)
#sudo yum -y install pcre pcre-devel perl-Crypt-SSLeay
#sudo yum -y libart_lgpl-devel

#yum -y install mailx libgcj GeoIP-devel aspell aspell-devel enchant-devel perl-ExtUtils libc-client libc-client-devel gdbm-devel bluez-libs-devel

sudo yum -y install unzip zip unrar rsync psmisc mediainfo iftop 
#yum -y install rar syslog-ng-libdbi help2man
########## RAR #############
echo ""
echo "Installing latest RAR..."
cd /tmp
rm -rf rar*
#wget https://www.rarlab.com/rar/rarlinux-x64-6.0.2.tar.gz
#wget https://www.rarlab.com/rar/rarlinux-x64-624.tar.gz
wget https://www.rarlab.com/rar/rarlinux-x64-723.tar.gz
tar xzf rarlinux-x64-*.tar.gz
cd rar*/
make
wget -O /etc/rarreg.key ${BASE_URL}replace/01_req_rarreg
cd ..
rm -rf rar*

############# SQLITE3 ######################
mv /usr/local/bin/sqlite3 /usr/local/bin/sqlite3_old

cd /tmp
rm -rf sqlite*
#wget https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz
#wget https://www.sqlite.org/2023/sqlite-autoconf-3440000.tar.gz
wget https://www.sqlite.org/2026/sqlite-autoconf-3530300.tar.gz
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
#sed -i "s,^.*umask 0.*,umask 002,g" /etc/bashrc

sudo tee /etc/profile.d/umask.sh >/dev/null <<'EOF'
umask 002
EOF

sudo chmod 644 /etc/profile.d/umask.sh


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
