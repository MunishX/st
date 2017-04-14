#!/bin/bash

#### PHP CONFIG

############################### ADDED START

# Take input for username and password
php_soft=$1
   while [[ $php_soft = "" ]]; do # to be replaced with regex
       read -p "Php-fpm Name: " php_soft
    done

tor_name=$2
   while [[ $tor_name = "" ]]; do # to be replaced with regex
       read -p "Transmission Name: " tor_name
    done


systemctl restart lighttpd.service
systemctl restart memcached
systemctl restart mysql
service $tor_name restart
service $php_soft restart

sleep 5

systemctl status lighttpd.service
#systemctl status $php_soft
systemctl status memcached
systemctl status mysql
service $tor_name status



