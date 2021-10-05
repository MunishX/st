#!/bin/bash

yum install sudo sed postfix -y
sudo sed -i "s/^inet_interfaces.*/inet_interfaces = ipv4/" /etc/postfix/main.cf

sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'

# postfix reload
service postfix restart

echo "Min Postfix Configured Successfully..."
