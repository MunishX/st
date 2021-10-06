#!/bin/bash

# cd /tmp/ && rm -rf /tmp/mailmin.sh && wget https://github.com/munishgaurav5/st/raw/master/final_tools/mailmin.sh && chmod 777 /tmp/mailmin.sh && ./tmp/mailmin.sh 

yum install sudo sed postfix -y
sudo sed -i "s/^inet_protocols.*/inet_protocols = ipv4/" /etc/postfix/main.cf

sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'

# postfix reload
service postfix restart

echo "Min Postfix Configured Successfully..."
