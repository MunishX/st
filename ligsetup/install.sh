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



#------------------------------------------------------------------------------------
# Vars
#------------------------------------------------------------------------------------

export MYSQL_DEFAULT_PASS=a
export FTP_DEFAULT_PASS=a

#------------------------------------------------------------------------------------
# Req Install and Update
#------------------------------------------------------------------------------------

cd /tmp
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/req.sh
chmod 777 req.sh
./req.sh

#------------------------------------------------------------------------------------
# Setup
#------------------------------------------------------------------------------------

cd /tmp

#------------------------------------------------------------------------------------
# Install Lighttpd
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/lig.sh
chmod 777 lig.sh
./lig.sh

#------------------------------------------------------------------------------------
# Install php
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/php.sh
chmod 777 php.sh
./php.sh

#------------------------------------------------------------------------------------
# Install db
#------------------------------------------------------------------------------------

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/db.sh
chmod 777 db.sh
./db.sh

#------------------------------------------------------------------------------------
# Install db pw up
#------------------------------------------------------------------------------------


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
