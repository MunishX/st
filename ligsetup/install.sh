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
# Setup
#------------------------------------------------------------------------------------

yum -y update
yum -y install wget

[ ! -d ~/scripts  ] && mkdir ~/scripts

cd ~/scripts

#------------------------------------------------------------------------------------
# Install apache
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/apache
. ./apache $DOMAIN $SERVER_NAME $ADMIN_EMAIL

#------------------------------------------------------------------------------------
# Install php
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/php
. ./php

#------------------------------------------------------------------------------------
# Install db
#------------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/samuelbirch/webserver/master/db
. ./db $USER

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
