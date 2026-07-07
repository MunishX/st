#!/bin/bash


# yum -y install wget && cd /tmp && rm -rf 00_install.sh && wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/00_install.sh && chmod 777 00_install.sh && ./00_install.sh
# yum -y install wget nano && cd /tmp && wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/00_install.sh && chmod 777 00_install.sh && nano 00_install.sh 



#------------------------------------------------------------------------------------
# Vars AND Inputs 
#------------------------------------------------------------------------------------
#NETWORK_INTERFACE_NAME="$(ip -o -4 route show to default | awk '{print $5}')"
NETWORK_INTERFACE_NAME="$(ip -o -4 route show to default | awk '{print $5}' | head -1)"

###### IP Check
#IPADDR=$(ip a s $NETWORK_INTERFACE_NAME |grep "inet "|awk '{print $2}'| awk -F '/' '{print $1}')
#or
#MAIN_IP="$(hostname -I)"
#MAIN_IP=$(ip a | grep "scope global" | grep -Po '(?<=inet )[\d.]+' | tr '\n' ' ' | awk '{print $1}')
MAIN_IP=$(ip a s "$NETWORK_INTERFACE_NAME" | grep "inet " | awk '{print $2}' | awk -F '/' '{print $1}' | head -1)
# Remove blank space
#MAIN_IP=${MAIN_IP//[[:blank:]]/}

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
       read -p "(3/9) Sub-Domain Part (ignore for www, ex:host) : " SERVER_HOST
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


Setup_IPv6=$6
echo ""
   while [[ $Setup_IPv6 = "" ]]; do # to be replaced with regex
       read -p "(9/9) Enable ipv6 for lighttpd (y/n): " Setup_IPv6
    done


ADMIN_USER=admin 
ADMIN_HTML=html

#------------------------------------------------------------------------------------
# READY :  Hostname & Admin User Setup
#------------------------------------------------------------------------------------

#### SETUP HOSTNAME AND HOST FILE

#OUT_HOSTNAME="$(hostname)"
OUT_HOSTNAME=$SERVER_HOST.$SERVER_DOMAIN

hostnamectl set-hostname $OUT_HOSTNAME

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

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/01_req.sh
chmod 777 01_req.sh
./01_req.sh

echo ""
echo ""
echo "1) REQ COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# SELINUX Disable
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/02_selinux.sh
chmod 777 02_selinux.sh
./02_selinux.sh

echo ""
echo ""
echo "2) SELINUX DISABLE COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# UPDATE SSH
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/03_ssh.sh
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

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/04_time.sh
chmod 777 04_time.sh
./04_time.sh

echo ""
echo ""
echo "4) TIME COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Add New user (incomplete) (ignored)
#------------------------------------------------------------------------------------
echo "5) Add New User Empty COMPLETED  (Ignored)!"
#------------------------------------------------------------------------------------
# Install CACHE
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/06_cache_redis_valkey.sh
chmod 777 06_cache_redis_valkey.sh
./06_cache_redis_valkey.sh

echo ""
echo ""
echo "6) CACHE COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# Install db
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/07_db.sh
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

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/08_dbpass.sh
chmod 777 08_dbpass.sh
./08_dbpass.sh $DB_PASS

echo ""
echo ""
echo "8) DB_PASS COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install Lighttpd
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/09_lig.sh
chmod 777 09_lig.sh
./09_lig.sh

echo ""
echo ""
echo "9) LIG COMPLETED!"
echo ""
sleep 10

#------------------------------------------------------------------------------------
# Install php
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/10_php.sh
chmod 777 10_php.sh
./10_php.sh

echo ""
echo ""
echo "10) PHP COMPLETED!"
echo ""
sleep 10



#------------------------------------------------------------------------------------
# Install LIG CONFIG 
#------------------------------------------------------------------------------------
restart_no=n

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/11_create_vhost.sh
chmod 777 11_create_vhost.sh
./11_create_vhost.sh $ADMIN_USER $ADMIN_PASS $SERVER_HOST $SERVER_DOMAIN $ADMIN_USER $Setup_IPv6 $restart_no y $MAIN_IP

echo ""
echo ""
echo "11) LIG CONFIG  COMPLETED!"
echo ""
sleep 10

#while [[ $Continue_do != "y" ]]; do # to be replaced with regex       
#       read -p "Press y to continue (y/n) : " Continue_do
#       #$MAIN_IP
#    done

#------------------------------------------------------------------------------------
# Software Install
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/12_soft.sh
chmod 777 12_soft.sh
./12_soft.sh $ADMIN_USER $OUT_HOSTNAME $ADMIN_HTML

echo ""
echo ""
echo "12) Software Install COMPLETED!"
echo ""
sleep 10




#------------------------------------------------------------------------------------
# Enable & RESTART ALL
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/13_restart.sh
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

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/14_firewall.sh
chmod 777 14_firewall.sh
./14_firewall.sh 

echo ""
echo ""
echo "14) Firewall COMPLETED!"
echo ""
sleep 10


#------------------------------------------------------------------------------------
# MAIL
#------------------------------------------------------------------------------------

wget https://github.com/MunishX/st/raw/refs/heads/master/ligsetup_rocky_10/15_mail.sh
chmod 777 15_mail.sh
./15_mail.sh 

echo ""
echo ""
echo "15) Mail COMPLETED!"
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
