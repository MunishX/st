#!/bin/bash

# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/install.sh && chmod 777 install.sh && ./install.sh
# yum -y install wget nano && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/install.sh && chmod 777 install.sh && nano install.sh 


#------------------------------------------------------------------------------------
# Vars AND Inputs 
#------------------------------------------------------------------------------------

###### IP Check
MAIN_IP="$(hostname -I)"

echo ""
echo ""

   while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "(1/7) SERVER MAIN IP is ${MAIN_IP} (y/n) : " IP_CORRECT
       #$MAIN_IP
    done

if [ $IP_CORRECT != "y" ]; then
   read -p "SERVER IP : " MAIN_IP
   #exit 1
   
      IP_CORRECT=
      while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "SERVER IP is ${MAIN_IP} (y/n) : " IP_CORRECT
       #$MAIN_IP
      done
fi


if [ $IP_CORRECT != "y" ]; then
   #read -p "SERVER IP : " MAIN_IP
   echo "Error!... Try Again!"
   exit 1
fi

#######

####### INPUT VARIABLES
ADMIN_PASS=$1
echo ""
   while [[ $ADMIN_PASS = "" ]]; do # to be replaced with regex
       read -p "(2/7) Admin Password (user : admin): " ADMIN_PASS
    done

SERVER_HOST=$2
echo ""
   while [[ $SERVER_HOST = "" ]]; do # to be replaced with regex
       read -p "(3/7) Host Name (host): " SERVER_HOST
    done

SERVER_DOMAIN=$3
echo ""
   while [[ $SERVER_DOMAIN = "" ]]; do # to be replaced with regex
       read -p "(4/7) Domain Name (domain.com): " SERVER_DOMAIN
    done

DB_PASS=$4
echo ""
   while [[ $DB_PASS = "" ]]; do # to be replaced with regex
       read -p "(5/7) MariaDB Root Password: " DB_PASS
    done

SSH_PORT=$5
echo ""
   while [[ $SSH_PORT = "" ]]; do # to be replaced with regex
       read -p "(6/7) SSH Port: " SSH_PORT
    done

ADMIN_USER=admin 
ADMIN_HTML=html

#------------------------------------------------------------------------------------
# READY :  Hostname & Admin User Setup
#------------------------------------------------------------------------------------

#### SETUP HOSTNAME AND HOST FILE

hostnamectl set-hostname $SERVER_HOST.$SERVER_DOMAIN

OUT_HOSTNAME="$(hostname)"
echo ""
while [[ $HOST_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "(7/7) Hostname is ${OUT_HOSTNAME} (y/n) : " HOST_CORRECT
       #$MAIN_IP
    done

if [ $HOST_CORRECT != "y" ]; then
   echo "Error!... Try Again!" 
   exit 1
fi

echo "$MAIN_IP $OUT_HOSTNAME $SERVER_HOST" >> /etc/hosts

#######################


##### Create Installer Folder
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
# INSTALL VPN
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/vpn.sh
chmod 777 vpn.sh
./vpn.sh

echo ""
echo ""
echo "2) VPN COMPLETED!"
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
echo "3) SSH COMPLETED!"
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
echo "4) TIME COMPLETED!"
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

#------------------------------------------------------------------------------------
# Install REPLACE
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace.sh
chmod 777 replace.sh
./replace.sh

echo ""
echo ""
echo "9) REPLACE COMPLETED!"
echo ""
sleep 10




#------------------------------------------------------------------------------------
# Install LIG CONFIG 
#------------------------------------------------------------------------------------
restart_no=n
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/ligconf.sh
chmod 777 ligconf.sh
./ligconf.sh $ADMIN_USER $ADMIN_PASS $OUT_HOSTNAME $ADMIN_USER $restart_no

echo ""
echo ""
echo "10) LIG CONFIG  COMPLETED!"
echo ""
sleep 10

while [[ $Continue_do != "y" ]]; do # to be replaced with regex       
       read -p "Press y to continue (y/n) : " Continue_do
       #$MAIN_IP
    done

#------------------------------------------------------------------------------------
# Software Install
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/soft.sh
chmod 777 soft.sh
./soft.sh $ADMIN_USER $ADMIN_HTML

echo ""
echo ""
echo "11) Software Install COMPLETED!"
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
