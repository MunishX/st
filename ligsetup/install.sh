#!/bin/bash

# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/install.sh && chmod 777 install.sh && ./install.sh

#------------------------------------------------------------------------------------
# Params
#------------------------------------------------------------------------------------

######
MAIN_IP="$(hostname -I)"
#IP_CORRECT=n

   while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "SERVER IP is ${MAIN_IP} (y/n) : " $IP_CORRECT
       #$MAIN_IP
    done

if [ $IP_CORRECT != "y" ]; then
   read -p "SERVER IP : " MAIN_IP
   #exit 1
   
      IP_CORRECT=
      while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "SERVER IP is ${MAIN_IP} (y/n) : " $IP_CORRECT
       #$MAIN_IP
      done


fi

if [ $IP_CORRECT != "y" ]; then
   #read -p "SERVER IP : " MAIN_IP
   echo "ERROR!"
   exit 1
fi

echo "IP CORRECT"
sleep 10
#######

ADMIN_PASS=$1
   while [[ $ADMIN_PASS = "" ]]; do # to be replaced with regex
       read -p "Admin Password (user : admin): " ADMIN_PASS
    done

SERVER_HOST=$2
   while [[ $SERVER_HOST = "" ]]; do # to be replaced with regex
       read -p "Host Name (mail): " SERVER_HOST
    done

SERVER_DOMAIN=$3
   while [[ $SERVER_DOMAIN = "" ]]; do # to be replaced with regex
       read -p "Domain Name (example.com): " SERVER_DOMAIN
    done

DB_PASS=$4
   while [[ $DB_PASS = "" ]]; do # to be replaced with regex
       read -p "MariaDB Root Password: " DB_PASS
    done

SSH_PORT=$5
   while [[ $SSH_PORT = "" ]]; do # to be replaced with regex
       read -p "SSH New Port: " SSH_PORT
    done


#------------------------------------------------------------------------------------
# READY :  Hostname & Admin User Setup
#------------------------------------------------------------------------------------

hostnamectl set-hostname $SERVER_HOST.$SERVER_DOMAIN
#hostname

OUT_HOSTNAME="$(hostname)"
#$HOST_CORRECT=a

while [[ $HOST_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "Hostname is ${OUT_HOSTNAME} (y/n) : " HOST_CORRECT
       #$MAIN_IP
    done

if [ $HOST_CORRECT != "y" ]; then
   echo "Hostname incorrect exiting..." 
   exit 1
fi

nano /etc/hosts
echo "" >> /etc/hosts
163.172.55.159 admin.fastshrink.com admin

rm -rf /tmp/lig_installer
mkdir -p /tmp/lig_installer
cd /tmp/lig_installer

echo ""
echo ""
echo "0) READY TO INSTALL!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Req Install and Update
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/req.sh
chmod 777 req.sh
./req.sh

echo ""
echo ""
echo "1) REQ COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Setup
#------------------------------------------------------------------------------------

#cd /tmp

#------------------------------------------------------------------------------------
# UPDATE SSH
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/ssh.sh
chmod 777 ssh.sh
./ssh.sh $SSH_PORT

echo ""
echo ""
echo "2) SSH COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# UPDATE TIME
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/time.sh
chmod 777 time.sh
./time.sh

echo ""
echo ""
echo "3) TIME COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# INSTALL VPN
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/vpn.sh
chmod 777 vpn.sh
./vpn.sh

echo ""
echo ""
echo "4) VPN COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# Install Lighttpd
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/lig.sh
chmod 777 lig.sh
./lig.sh

echo ""
echo ""
echo "5) LIG COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install php
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/php.sh
chmod 777 php.sh
./php.sh

echo ""
echo ""
echo "6) PHP COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install db
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/db.sh
chmod 777 db.sh
./db.sh

echo ""
echo ""
echo "7) DB COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install db pw up
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/dbpass.sh
chmod 777 dbpass.sh
./dbpass.sh $DB_PASS

echo ""
echo ""
echo "8) DB_PASS COMPLETED!"
echo ""
sleep 10

echo "END!!"
exit 1

#------------------------------------------------------------------------------------
# Install ftp
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/ftp
. ./ftp $USER $SERVER_NAME.$DOMAIN

#------------------------------------------------------------------------------------
# Install fail2ban
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/fail2ban
. ./fail2ban

#------------------------------------------------------------------------------------
# Install firewall
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/firewall
. ./firewall

#------------------------------------------------------------------------------------
# Install mail
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/mail
. ./mail $DOMAIN $SERVER_NAME

#------------------------------------------------------------------------------------
# Download vhost
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/vhost

#------------------------------------------------------------------------------------
# Output
#------------------------------------------------------------------------------------

echo "All done!"
echo "Your MYSQL password is $MYSQL_DEFAULT_PASS"
echo "Your FTP root password is $FTP_DEFAULT_PASS"
