#!/bin/bash

#####################################################
#####################################################

# Take input for username and password
uname=$1
   while [[ $uname = "" ]]; do # to be replaced with regex
       read -p "Transmission username: " uname
    done

passw=$2
   while [[ $passw = "" ]]; do # to be replaced with regex
       read -p "$uname's Password: " passw
    done

myport=$3
   while [[ $myport = "" ]]; do # to be replaced with regex
       read -p "$uname's Port: " myport
    done

mydom=$4
   while [[ $mydom = "" ]]; do # to be replaced with regex
       read -p "$uname's Domain: " mydom
    done

admin_uname=$5
   while [[ $admin_uname = "" ]]; do # to be replaced with regex
       read -p "$uname's Group: " admin_uname
    done
    
user_old=$6
   while [[ $user_old = "" ]]; do # to be replaced with regex
       read -p "Is this new user ? (y/n): " user_old
    done
    

#read -p "Transmission username: " uname
#read -p "$uname's Password: " passw

software_root=tor
software_name=${software_root}-${uname}

##########

#### Check User Status
USERID=${uname}
STOP_IT=0

/bin/id -u $USERID 2>/dev/null
if [ $? -eq 0 ]; then
   echo "User $USERID already exists."
   STOP_IT=1
else
   echo "UserID : OK"
fi

/bin/id -g $USERID 2>/dev/null
if [ $? -eq 0 ]; then
   echo "Group $USERID already exists."
   STOP_IT=1
else
   echo "GroupID : OK"
fi

if [[ $STOP_IT = 1 ]]; then
echo 'Error! Username already available. Please change Username and try again.'
exit 1
fi

echo 'User Status :  OK'

###########

#### check full install or half

file="/usr/bin/transmission-daemon"
if [ -f "$file" ]
then
	echo "Selected Mode : Add User Only "
   install_type="n"
else
	echo "Selected Mode : Full Install + Add User "
   install_type="y"
fi

sleep 3



############################################################
########################## START INSTALL ##################################

# Update system and install required packages
yum -y update
yum -y install gcc gcc-c++ m4 xz make automake curl-devel intltool libtool gettext openssl-devel perl-Time-HiRes wget

if [ $user_old != "y" ]; then
#Create UNIX user and directories for transmission
encrypt_pass=$(perl -e 'print crypt($ARGV[0], "password")' $passw)
useradd -m -p $encrypt_pass $uname
fi

mkdir -p /home/$uname/Downloads/
chown -R $uname:$admin_uname /home/$uname/Downloads/
chmod -R 777 /home/$uname/Downloads/

## Install the firewall (CSF)
#cd /usr/local/src
#wget http://configserver.com/free/csf.tgz
#tar xzf csf.tgz
#cd csf
#./install.generic.sh
#cd /etc/csf
#sed -i 's/^TESTING =.*/TESTING = "0"/' csf.conf
#sed -i 's/^TCP_IN =.*/TCP_IN = "22,80,9091,10000,51413"/' csf.conf
#sed -i 's/^TCP_OUT =.*/TCP_OUT = "1:65535"/' csf.conf
#sed -i 's/^UDP_IN =.*/UDP_IN = "51413"/' csf.conf
#sed -i 's/^UDP_OUT =.*/UDP_OUT = "1:65535"/' csf.conf
#csf -r

# Install libevent
#cd /usr/local/src
#wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
#tar xzf libevent-2.0.22-stable.tar.gz
#cd libevent-2.0.22-stable
#./configure --prefix=/usr
#make
#make install

##### install all softwares

if [[ $install_type = "y" ]]; then


# Install libevent
cd /usr/local/src
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar xzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=/usr
make
make install

# Where are those libevent libraries?
echo /usr/lib > /etc/ld.so.conf.d/libevent-i386.conf
echo /usr/lib > /etc/ld.so.conf.d/libevent-x86_64.conf
ldconfig
export PKG_CONFIG_PATH=/usr/lib/pkgconfig

# Install transmission
#cd /usr/local/src
#wget https://transmission.cachefly.net/transmission-2.84.tar.xz
#tar xvf transmission-2.84.tar.xz
#cd transmission-2.84
#./configure --prefix=/usr
#make
#make install

# Install transmission
cd /usr/local/src
wget https://github.com/transmission/transmission-releases/raw/master/transmission-2.92.tar.xz
tar xvf transmission-2.92.tar.xz
cd transmission-2.92
./configure --prefix=/usr
make
make install

    fi



# Set up init script for transmission-daemon
cd /etc/init.d
wget -O $software_name https://gist.githubusercontent.com/elijahpaul/b98f39011bce48c0750d/raw/0812b6d949b01922f7060f4d4d15dc5e70c5d5a5/transmission-daemon
sed -i "s%TRANSMISSION_HOME=/home/transmission%TRANSMISSION_HOME=/home/$uname%" $software_name
sed -i 's%DAEMON_USER="transmission"%DAEMON_USER="placeholder123"%' $software_name
sed -i "s%placeholder123%$uname%" $software_name
chmod 755 /etc/init.d/$software_name
chkconfig --add $software_name
chkconfig --level 345 $software_name on

##### UPDATE BIN FILE
## only centos 7 supported 
cp /usr/bin/transmission-daemon /usr/bin/$software_name

cd /etc/init.d
sed -i "s%processname: transmission-daemon%processname: $software_name%" $software_name
sed -i "s%NAME=transmission-daemon%NAME=$software_name%" $software_name

#update /etc/init.d/transmissiond
#processname: transmission-daemon2
#NAME=transmission-daemon2
systemctl daemon-reload
##########

# Edit the transmission configuration
service $software_name start
service $software_name stop
sleep 3

cd /home/$uname/.config/transmission
sed -i 's/^.*rpc-authentication-required.*/"rpc-authentication-required": true,/' settings.json
sed -i 's/^.*download-queue-enabled.*/"download-queue-enabled": false,/' settings.json
sed -i 's/^.*peer-limit-global.*/"peer-limit-global": 9000,/' settings.json
sed -i 's/^.*peer-limit-per-torrent.*/"peer-limit-per-torrent": 500,/' settings.json
sed -i 's/^.*peer-port-random-on-start.*/"peer-port-random-on-start": true,/' settings.json
sed -i 's/^.*"ratio-limit".*/"ratio-limit": 0,/' settings.json
sed -i 's/^.*ratio-limit-enabled.*/"ratio-limit-enabled": true,/' settings.json
sed -i 's/^.*rpc-whitelist-enabled.*/"rpc-whitelist-enabled": false,/' settings.json
sed -i 's/^.*speed-limit-up-enabled.*/"speed-limit-up-enabled": true,/' settings.json
sed -i 's/^.*umask.*/"umask": 2,/' settings.json

sed -i 's/^.*rpc-username.*/"rpc-username": "placeholder123",/' settings.json
sed -i 's/^.*rpc-password.*/"rpc-password": "placeholder321",/' settings.json
sed -i 's/^.*rpc-port.*/"rpc-port": placeholderport,/' settings.json

sed -i "s/placeholderport/$myport/" settings.json
sed -i "s/placeholder123/$uname/" settings.json
sed -i "s/placeholder321/$passw/" settings.json

# "peer-port-random-on-start": false,
# "rpc-port": 9091,
# "rpc-username": "admin",

sed -i 's;^.*download-dir.*;"download-dir": "/home/__UNAME__/__DNAME__/html/safe/disk/",;' settings.json
sed -i "s/__UNAME__/$uname/" settings.json
sed -i "s/__DNAME__/$mydom/" settings.json


mkdir -p /home/$uname/$mydom/html/safe/disk/
chown -R $uname:$admin_uname /home/$uname/
chmod -R 777 /home/$uname/$mydom/html/safe
rm -rf /home/$uname/Download*


# Yay!!!
service $software_name start
