#!/bin/bash

umask
umask 0002
umask

sleep 6
# yum -y install wget && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/install.sh && chmod 777 install.sh && ./install.sh
# yum -y install wget nano && cd /tmp && wget https://github.com/munishgaurav5/st/raw/master/ligsetup/install.sh && chmod 777 install.sh && nano install.sh 


#------------------------------------------------------------------------------------
# Vars AND Inputs 
#------------------------------------------------------------------------------------

###### IP Check
IPADDR=$(ip a s eth0 |grep "inet "|awk '{print $2}'| awk -F '/' '{print $1}')
#or
MAIN_IP="$(hostname -I)"
# Remove blank space
MAIN_IP=${MAIN_IP//[[:blank:]]/}

echo ""
echo ""

   while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "(1/9) SERVER MAIN IP is '${MAIN_IP}' (y/n) : " IP_CORRECT
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
       read -p "(2/9) Admin Password (user : admin): " ADMIN_PASS
    done

SERVER_HOST=$2
echo ""
   while [[ $SERVER_HOST = "" ]]; do # to be replaced with regex
       read -p "(3/9) Host Name (host): " SERVER_HOST
    done

SERVER_DOMAIN=$3
echo ""
   while [[ $SERVER_DOMAIN = "" ]]; do # to be replaced with regex
       read -p "(4/9) Domain Name (domain.com): " SERVER_DOMAIN
    done

DB_PASS=$4
echo ""
   while [[ $DB_PASS = "" ]]; do # to be replaced with regex
       read -p "(5/9) MariaDB Root Password: " DB_PASS
    done

SSH_PORT=$5
echo ""
   while [[ $SSH_PORT = "" ]]; do # to be replaced with regex
       read -p "(6/9) SSH Port: " SSH_PORT
    done

Install_VPN=$6
echo ""
   while [[ $Install_VPN = "" ]]; do # to be replaced with regex
       read -p "(7/9) INSTALL VPN (y/n): " Install_VPN
    done

Install_Torrent=$7
echo ""
   while [[ $Install_Torrent = "" ]]; do # to be replaced with regex
       read -p "(8/9) INSTALL Torrent (y/n): " Install_Torrent
    done

if [ $Install_Torrent = "y" ]; then
   
   Torrent_Port=$8
   echo ""
   while [[ $Torrent_Port = "" ]]; do # to be replaced with regex
       read -p "(8/9) Torrent Port (9091): " Torrent_Port
    done
  
fi

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
       read -p "(9/9) Hostname is ${OUT_HOSTNAME} (y/n) : " HOST_CORRECT
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

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/01_req.sh
chmod 777 01_req.sh
./01_req.sh

echo ""
echo ""
echo "1) REQ COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# INSTALL VPN
#------------------------------------------------------------------------------------
if [[ $Install_VPN = "y" ]]; then

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/02_vpn.sh
chmod 777 02_vpn.sh
./02_vpn.sh

echo ""
echo ""
echo "2) VPN COMPLETED!"
echo ""

else
echo ""
echo ""
echo "2) SKIPPING VPN!"
echo ""
fi


sleep 10



#------------------------------------------------------------------------------------
# UPDATE SSH
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/03_ssh.sh
chmod 777 03_ssh.sh
./03_ssh.sh $SSH_PORT

echo ""
echo ""
echo "3) SSH COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# UPDATE TIME
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/04_time.sh
chmod 777 04_time.sh
./04_time.sh

echo ""
echo ""
echo "4) TIME COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# Install Lighttpd
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/05_lig.sh
chmod 777 05_lig.sh
./05_lig.sh

echo ""
echo ""
echo "5) LIG COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install php
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/06_php.sh
chmod 777 06_php.sh
./06_php.sh

echo ""
echo ""
echo "6) PHP COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install db
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/07_db.sh
chmod 777 07_db.sh
./07_db.sh

echo ""
echo ""
echo "7) DB COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install db pw up
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/08_dbpass.sh
chmod 777 08_dbpass.sh
./08_dbpass.sh $DB_PASS

echo ""
echo ""
echo "8) DB_PASS COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install REPLACE
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/09_replace.sh
chmod 777 09_replace.sh
./09_replace.sh

echo ""
echo ""
echo "9) REPLACE COMPLETED!"
echo ""
sleep 10




#------------------------------------------------------------------------------------
# Install LIG CONFIG 
#------------------------------------------------------------------------------------
restart_no=n
#wget https://github.com/munishgaurav5/st/raw/master/ligsetup/ligconf.sh
#chmod 777 ligconf.sh
#./ligconf.sh $ADMIN_USER $ADMIN_PASS $OUT_HOSTNAME $ADMIN_USER $restart_no

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/10_create_vhost.sh
chmod 777 10_create_vhost.sh
./10_create_vhost.sh $ADMIN_USER $ADMIN_PASS $OUT_HOSTNAME $ADMIN_USER $restart_no

echo ""
echo ""
echo "10) LIG CONFIG  COMPLETED!"
echo ""
sleep 10

#while [[ $Continue_do != "y" ]]; do # to be replaced with regex       
#       read -p "Press y to continue (y/n) : " Continue_do
#       #$MAIN_IP
#    done

#------------------------------------------------------------------------------------
# Software Install
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/11_soft.sh
chmod 777 11_soft.sh
./11_soft.sh $ADMIN_USER $OUT_HOSTNAME $ADMIN_HTML

echo ""
echo ""
echo "11) Software Install COMPLETED!"
echo ""
sleep 10



#------------------------------------------------------------------------------------
# Install Torrent
#------------------------------------------------------------------------------------

if [[ $Install_Torrent = "y" ]]; then

old_user_true=y
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/12_tmm.sh
chmod 777 12_tmm.sh 
./12_tmm.sh $ADMIN_USER $ADMIN_PASS $Torrent_Port $OUT_HOSTNAME $ADMIN_USER $old_user_true

echo ""
echo ""
echo "12) Torrent COMPLETED!"
echo ""

else
echo ""
echo ""
echo "12) SKIPPING Torrent!"
echo ""
fi


sleep 10



#------------------------------------------------------------------------------------
# Enable & RESTART ALL
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/13_restart.sh
chmod 777 13_restart.sh
./13_restart.sh $OUT_HOSTNAME $ADMIN_USER 

echo ""
echo ""
echo "13) Restart and Enable COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# FIREWALL
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/14_firewall.sh
chmod 777 14_firewall.sh
./14_firewall.sh 

echo ""
echo ""
echo "14) Firewall COMPLETED!"
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
