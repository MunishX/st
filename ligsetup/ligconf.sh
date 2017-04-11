#!/bin/bash

#### LIGHTTPD CONFIG


#### FASTCGI CONFIG


#### MODULES CONFIG


#### PHP CONFIG

uname=$1
admin_username=$2

php_add_head=php
software_name=${php_add_head}-${uname}
user_root=/home/$uname/
user_php=php
admin_bin_loc=/home/$admin_username/bin/

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/www -O $user_root$user_php/$software_name.conf
sed -i "s,^.*/run/php-fpm-pool.pid.*,pid = $user_root$user_php/$software_name.pid," $user_root$user_php/$software_name.conf
sed -i "s/^.*www-name.*/[$software_name]/" $user_root$user_php/$software_name.conf
sed -i "s/^.*user-name.*/user = $uname/" $user_root$user_php/$software_name.conf
sed -i "s/^.*group-name.*/group = $uname/" $user_root$user_php/$software_name.conf
sed -i "s,^.*/run/php70-php-fpm.sock.*,listen = $user_root$user_php/$software_name.sock," $user_root$user_php/$software_name.conf
sed -i "s/^.*listen-u-name.*/listen.acl_users = $uname/" $user_root$user_php/$software_name.conf
sed -i "s,/user-php-root/,$user_root$user_php/,g" $user_root$user_php/$software_name.conf

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/intl -O $admin_bin_loc/$software_name
#sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/www.conf.*,php_fpm_CONF=$user_root$user_php/$software_name.conf," $admin_bin_loc/$software_name
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$user_root$user_php/$software_name.pid," $admin_bin_loc/$software_name
chmod 777 $admin_bin_loc/$software_name

chown -R $uname:$uname $user_root
chown -R $admin_username:$uname $user_root/logs

echo "Done!!!!!"

bash $admin_bin_loc/$software_name start

#chown -R admin:admin /var/opt/remi/php70
#####################

#fastcgi.conf
#Admin php sock


#lighttpd.conf
## enabled folder : /etc/lighttpd/enabled/*.conf
## admin php sock : /run/php-admin.sock
## ip home : /home/admin/html/ip
## user : admin:admin
## folders : html,logs,php,bin
#modules.conf
#ok


