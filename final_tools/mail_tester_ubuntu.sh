#!/bin/bash


# for ubuntu or debian 

## service file path
## /etc/systemd/system/ in ubuntu system
## systemctl daemon-reload

# cd /tmp && sudo apt install wget -y && rm -rf /tmp/mail_tester_ubuntu.sh && wget http://host.fastserver.me/tmp/mail_tester_ubuntu.sh && chmod 777 mail_tester_ubuntu.sh && bash /tmp/mail_tester_ubuntu.sh

sudo apt update -y
sudo apt install -y nano wget curl sed openssl unzip zip  
sudo apt install -y software-properties-common

#sudo wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -
#sudo echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
#sudo apt update -y

cd /tmp
wget -O sury.sh https://packages.sury.org/php/README.txt
chmod 777 sury.sh
./sury.sh

sudo apt install -y php7.4 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-soap php7.4-xml php7.4-zip php7.4-xmlrpc php-imagick php7.4-bcmath php-dompdf php-fpm php-mysql php7.4-memcache php7.4-memcached php7.4-geoip php7.4-gnupg  php7.4-fpm php7.4-bz2 php7.4-mbstring

sleep 2

php7.4 -v

sleep 2


# postfix install

apt install sudo sed postfix -y
sudo sed -i "s/^inet_protocols.*/inet_protocols = ipv4/" /etc/postfix/main.cf

sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'

sudo postconf -e 'smtp_host_lookup = native'
sudo postconf -e 'lmtp_host_lookup = native'

# postfix reload
service postfix restart

echo "Min Postfix Configured Successfully..."


#Apache install

#sudo apt install -y apache2 libapache2-mod-php
sudo apt install -y apache2 libapache2-mod-php7.4
rm -rf /var/www/html/up.php /var/www/html/PHPMailer*
sudo wget -O /var/www/html/up.php https://github.com/dulldusk/phpfm/raw/master/index.php

chown -R www-data:www-data /var/www/html


# PHPMailer install

cd /var/www/html
wget http://host.fastserver.me/tmp/PHPMailer.zip
#wget -O PHPMailer.zip https://github.com/PHPMailer/PHPMailer/archive/refs/tags/v6.6.3.zip
unzip PHPMailer.zip
chown -R www-data:www-data /var/www/html


#hostname setup

hostnamectl set-hostname test10.fastserver.me

echo ""
echo "SETUP Configured Successfully..."
echo ""
echo ""
echo "if need to change hostname, run: hostnamectl set-hostname test10.fastserver.me "
echo "set A record"
echo "set SPF record"
echo "set reverse IP Host at Network"
echo ""
echo " Then visit http://[IP]/PHPMailer/src/test.php or http://test10.fastserver.me/PHPMailer/src/test.php"
echo ""


