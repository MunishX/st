#!/bin/bash

ADMIN_USER_NAME=$1
echo ""
   while [[ $ADMIN_USER_NAME = "" ]]; do # to be replaced with regex
       read -p "Enter Admin UserName : " ADMIN_USER_NAME
    done

mydom=$2
   while [[ $mydom = "" ]]; do # to be replaced with regex
       read -p "$ADMIN_USER_NAME's Domain: " mydom
    done

ADMIN_PUBLIC_HTML=$3
echo ""
   while [[ $ADMIN_PUBLIC_HTML = "" ]]; do # to be replaced with regex
       read -p "Enter Public_Html dir (html) : " ADMIN_PUBLIC_HTML
    done

mkdir -p /home/$ADMIN_USER_NAME/$mydom/$ADMIN_PUBLIC_HTML/host/
cd /home/$ADMIN_USER_NAME/$mydom/$ADMIN_PUBLIC_HTML/host/


################### AWSTATS INSTALL ########################
#yum install awstats -y 

mkdir -p cgi-bin
wget https://github.com/munishgaurav5/st/raw/master/aw76.zip
unzip aw76.zip
mv awstats-7.6/wwwroot/ awstats
mv awstats/cgi-bin/* cgi-bin
rm -rf aw76.zip awstats-7.6

########
wget https://raw.github.com/munishgaurav5/st/master/default.conf -O cgi-bin/default.conf
########

echo "
<html> 
<meta http-equiv=\"refresh\" content=\"0; URL=awstats.pl?config=admin\"> 
</html> 
    " > cgi-bin/index.php

###########################################

#wget wget https://svwh.dl.sourceforge.net/project/phpfm/phpFileManager/version%200.9.8/phpFileManager-0.9.8.zip --no-check-certificate
#wget http://ncu.dl.sourceforge.net/project/phpfm/phpFileManager/version%200.9.8/phpFileManager-0.9.8.zip
#wget http://ncu.dl.sourceforge.net/project/phpfm/phpFileManager/version%200.9.9/phpFileManager-0.9.9.zip

#wget https://raw.github.com/munishgaurav5/st/master/pFM98.zip -O phpFileManager-0.9.9.zip
wget https://github.com/Th3-822/rapidleech/archive/master.zip
unzip master
#unzip php*
#rm -rf phpF*.zip
##rm -rf master*.zip
#rm -rf LICENSE.html
#mv index.php up.php
mv rapidleech-master test
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/man.php -O up.php

mkdir autoload
echo "composer require fruitcakestudio/recaptcha" > autoload/note.txt
echo "composer create-project kleiram/transmission-php --keep-vcs -s dev ftl" >> autoload/note.txt


mkdir admin
touch admin/php.php

mkdir status
cd status

wget https://github.com/munishgaurav5/st/raw/master/opcache.php
wget https://github.com/munishgaurav5/st/raw/master/ocp.php
wget https://github.com/munishgaurav5/st/raw/master/op.php
wget https://github.com/munishgaurav5/st/raw/master/mem.php

wget https://raw.github.com/munishgaurav5/st/master/mem.zip
unzip mem.zip
rm -rf mem.zip
# /run/memcached/memcached.sock

############# PHPmyadmin  ##################

# yum -y remove php56u-mysql
# yum -y install php56u-mysqlnd

# PHP 5.5 or > Required

#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.1/phpMyAdmin-4.7.1-all-languages.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.2/phpMyAdmin-4.7.2-english.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.3/phpMyAdmin-4.7.3-english.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.4/phpMyAdmin-4.7.4-english.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.7/phpMyAdmin-4.7.7-english.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.7.8/phpMyAdmin-4.7.8-english.zip
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-english.zip
unzip phpMy*
rm -rf phpMy*.zip
mv phpMy* php

cd php
#cp config.sample.inc.php config.inc.php

echo "<?php \$cfg['blowfish_secret'] = 'ykuglihlufjtfjguhigkughkuhkuhkgyfjohbjbhfjthtvjyhguhlihhkygyjfgtfj'; ?>" > config.inc.php
cd ..


##########################################

############# vnSTAT Network Traffic  ############

yum -y install vnstat
#apt -y install vnstat

NETWORK_INTERFACE_NAME="$(ip -o -4 route show to default | awk '{print $5}')"

echo ""
echo "Network Interface Name : ${NETWORK_INTERFACE_NAME}"
sleep 2

#vnstat -i eth0
#vnstat -u -i eth0

vnstat -i $NETWORK_INTERFACE_NAME
vnstat -u -i $NETWORK_INTERFACE_NAME

*/5 * * * * /usr/bin/vnstat -u >/dev/null 2>&1
chown -R vnstat:vnstat /var/lib/vnstat

########
wget https://raw.github.com/munishgaurav5/st/master/vn.zip -O vnstat.zip
########

unzip vnstat.zip
rm -rf vnstat.zip
mv vnstat stat

if [ $NETWORK_INTERFACE_NAME != "eth0" ]; then
sed -i "s/^.*eth0.*/ '$NETWORK_INTERFACE_NAME',/" stat/config.php
fi

service vnstat start
chkconfig vnstat on
vnstat -d


############## PHP COMPOSER #########################
#cd /tmp
# sudo -y apt-get install snmp

curl -sS https://getcomposer.org/installer | php

mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
composer -V

###########################################


########## CronKeep INSTALL

#curl -sS https://getcomposer.org/installer | php
#php composer.phar create-project cronkeep/cronkeep --keep-vcs -s dev /var/www/html/.time/.pass/.masti/.web/html/status/cron
composer create-project cronkeep/cronkeep --keep-vcs -s dev cron

echo "<?php header(\"Location: src/\"); ?> " > cron/index.php

#####

chown -R $ADMIN_USER_NAME:$ADMIN_USER_NAME /home/$ADMIN_USER_NAME

echo "DONE!"
