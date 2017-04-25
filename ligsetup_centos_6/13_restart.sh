#!/bin/bash

#### PHP CONFIG

############################### ADDED START

# Take input for username and password
php_soft=$1
   while [[ $php_soft = "" ]]; do # to be replaced with regex
       read -p "Php-fpm Name: " php_soft
    done

tor_soft=$2
   while [[ $tor_soft = "" ]]; do # to be replaced with regex
       read -p "Transmission Name: " tor_soft
    done

#php_name=$3
#   while [[ $php_name = "" ]]; do # to be replaced with regex
#       read -p "PHP Name: " php_name
#    done

php_name=php

#tor_name=$3
#   while [[ $tor_name = "" ]]; do # to be replaced with regex
#       read -p "Transmission Name: " tor_name
#    done

tor_name=tor



service lighttpd start
chkconfig lighttpd on
#systemctl enable  lighttpd.service

#systemctl start php70-php-fpm 
#systemctl enable php70-php-fpm

#systemctl enable memcached
#systemctl start memcached
chkconfig memcached on
service memcached start

sleep 5

service lighttpd restart
service memcached restart
service mysql restart

service $tor_name-$tor_soft restart
service $php_name-$php_soft restart

sleep 5

service lighttpd status
service memcached status
service mysql status
service $tor_name-$tor_soft status

#systemctl status lighttpd.service
#systemctl status $php_soft
#systemctl status memcached
#systemctl status mysql




