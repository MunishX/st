#!/bin/bash


mkdir -p /home/html/
cd /home/html/


################### AWSTATS INSTALL ########################
#yum install awstats -y 

mkdir -p cgi-bin
wget https://prdownloads.sourceforge.net/awstats/awstats-7.6.zip
unzip awstats-*.zip
mv awstats-7.6/wwwroot/ awstats
mv awstats/cgi-bin/* cgi-bin
rm -rf awstats-*

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

wget https://raw.github.com/munishgaurav5/st/master/pFM98.zip -O phpFileManager-0.9.9.zip
wget https://github.com/Th3-822/rapidleech/archive/master.zip
unzip master
unzip php*
rm -rf phpF*.zip
rm -rf master*.zip
rm -rf LICENSE.html
mv index.php up.php
mv rapidleech-master test

mkdir autoload
echo "composer require fruitcakestudio/recaptcha" > autoload/note.txt
echo "composer create-project kleiram/transmission-php --keep-vcs -s dev ftl" >> autoload/note.txt


mkdir status
cd status
wget https://raw.github.com/rlerdorf/opcache-status/master/opcache.php
wget https://gist.github.com/ck-on/4959032/raw/0b871b345fd6cfcd6d2be030c1f33d1ad6a475cb/ocp.php
wget https://raw.github.com/amnuts/opcache-gui/master/index.php -O op.php
wget https://raw.github.com/munishgaurav5/st/master/mem.zip -O mem.zip
unzip mem.zip
rm -rf mem.zip
wget https://raw.githubusercontent.com/kn007/memcache.php/master/memcache.php -O mem.php
# /run/memcached/memcached.sock

############# PHPmyadmin  ##################

# yum -y remove php56u-mysql
# yum -y install php56u-mysqlnd

# PHP 5.5 or > Required

#wget https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.zip
#wget https://files.phpmyadmin.net/phpMyAdmin/4.6.6/phpMyAdmin-4.6.6-all-languages.zip
wget https://files.phpmyadmin.net/phpMyAdmin/4.7.0/phpMyAdmin-4.7.0-all-languages.zip
unzip phpM*
rm -rf phpM*.zip
mv phpM* php

cd php
#cp config.sample.inc.php config.inc.php

echo "<?php \$cfg['blowfish_secret'] = 'ykuglihlufjtfjguhigkughkuhkuhkgyfjohbjbhfjthtvjyhguhlihhkygyjfgtfj'; ?>" > config.inc.php
cd ..


##########################################

############# vnSTAT Network Traffic  ############

yum -y install vnstat
#apt -y install vnstat
vnstat -i eth0
vnstat -u -i eth0
*/5 * * * * /usr/bin/vnstat -u >/dev/null 2>&1
chown -R vnstat:vnstat /var/lib/vnstat

##cd /tmp
#wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
#tar xzf vnstat_php_frontend-1.5.1.tar.gz
#rm -rf vnstat_php_frontend-1.5.1.tar.gz
#mv vnstat_php_frontend-1.5.1 stat

## eth0 em1 venet0

#wget http://s1.fastrapidleech.com/vnstat.zip

########
wget https://raw.github.com/munishgaurav5/st/master/vn.zip -O vnstat.zip
########

unzip vnstat.zip
rm -rf vnstat.zip
mv vnstat stat


service vnstat start
chkconfig vnstat on
vnstat -d


############## SSH POrt Change #########################

echo "Port 1997" >> /etc/ssh/sshd_config
service sshd restart

firewall-cmd --permanent --zone=public --add-port=1997/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

###########################################

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

echo "DONE!"
