#!/bin/bash
echo "MAINTAINER XYZ"
sleep 2

#######################################
#cd /tmp
#wget https://raw.github.com/munishgaurav5/st/master/ms.sh
#chmod 777 ms.sh
#./ms.sh


#cd /tmp
#wget https://raw.github.com/munishgaurav5/st/master/dk.sh
#chmod 777 dk.sh
#./dk.sh

###########
#WORK_TODO=$1

WEBSITE_NAME=$1
DKIM_SELECTOR=$2


   while [[ $WEBSITE_NAME = "" ]]; do # to be replaced with regex
        read -p "Website (website.com/mail.website.com): " WEBSITE_NAME
    done
   while [[ $DKIM_SELECTOR = "" ]]; do # to be replaced with regex
        read -p "WEBMAIL HOST (e.g. default): " DKIM_SELECTOR
    done

	
    echo "Working..."
sleep 3

#######################################


mkdir -p /etc/opendkim/keys/$WEBSITE_NAME

#/usr/sbin/opendkim-genkey -b 2048 -S -a -r -s $DKIM_SELECTOR -d $WEBSITE_NAME -D /etc/opendkim/keys/$WEBSITE_NAME/
#/usr/sbin/opendkim-genkey -D /etc/opendkim/keys/cmail.cf/ -b 2048 -d cmail.cf -s $DKIM_SELECTOR

#/usr/sbin/opendkim-genkey -D /etc/opendkim/keys/$WEBSITE_NAME/ -d $WEBSITE_NAME -s $DKIM_SELECTOR
/usr/sbin/opendkim-genkey -b 1024 -S -a -r -s $DKIM_SELECTOR -d $WEBSITE_NAME -D /etc/opendkim/keys/$WEBSITE_NAME/

chown -R opendkim:opendkim /etc/opendkim/keys/

echo "*@$WEBSITE_NAME $DKIM_SELECTOR._domainkey.$WEBSITE_NAME" >> /etc/opendkim/SigningTable
echo "*$DKIM_SELECTOR._domainkey.$WEBSITE_NAME $WEBSITE_NAME:$DKIM_SELECTOR:/etc/opendkim/keys/$WEBSITE_NAME/$DKIM_SELECTOR.private" >> /etc/opendkim/KeyTable
#mv /etc/opendkim/keys/$WEBSITE_NAME/$DKIM_SELECTOR.private /etc/opendkim/keys/$WEBSITE_NAME/$DKIM_SELECTOR
#echo "$WEBSITE_NAME" >> /etc/opendkim/TrustedHosts


#systemctl restart postfix dovecot httpd mariadb amavisd clamd@amavisd spamassassin opendkim
#systemctl restart postfix dovecot opendkim
systemctl restart opendkim

cat /etc/opendkim/keys/$WEBSITE_NAME/$DKIM_SELECTOR.txt
