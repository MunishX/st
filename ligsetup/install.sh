#!/bin/bash

#------------------------------------------------------------------------------------
# Params
#------------------------------------------------------------------------------------

echo -e "What is the server domain: \c "
read DOMAIN

echo -e "What is the server name (subdomain): \c "
read SERVER_NAME

echo -e "What is the mail subdomain: \c "
read MAIL_DOMAIN

echo -e "What is the admin email: \c "
read ADMIN_EMAIL

echo -e "What is the default user: \c "
read USER

echo -e "Setup Root Password for MariaDB : \c "
read DB_PASS



#------------------------------------------------------------------------------------
# Vars
#------------------------------------------------------------------------------------

#export MYSQL_DEFAULT_PASS=a
#export FTP_DEFAULT_PASS=a

#------------------------------------------------------------------------------------
# Req Install and Update
#------------------------------------------------------------------------------------

cd /tmp
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

cd /tmp

#------------------------------------------------------------------------------------
# UPDATE SSH
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/ssh.sh
chmod 777 ssh.sh
./ssh.sh

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
