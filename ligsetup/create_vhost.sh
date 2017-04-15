#!/bin/bash

#### PHP CONFIG

############################### ADDED START
main_ip="$(hostname -I)"

# Take input for username and password
uname=$1
   while [[ $uname = "" ]]; do # to be replaced with regex
       read -p "VHost username: " uname
    done

passw=$2
   while [[ $passw = "" ]]; do # to be replaced with regex
       read -p "$uname's Password: " passw
    done

mydom=$3
   while [[ $mydom = "" ]]; do # to be replaced with regex
       read -p "$uname's Domain: " mydom
    done

admin_username=$4
   while [[ $admin_username = "" ]]; do # to be replaced with regex
       read -p "ADMIN USERNAME: " admin_username
    done

restart_now=$5
   while [[ $restart_now = "" ]]; do # to be replaced with regex
       read -p "Restart Lighttpd after Finish (y/n) : " restart_now
    done

#main_ip_ok=$6
#   while [[ $main_ip_ok = "" ]]; do # to be replaced with regex
#       read -p "SERVER MAIN IP is ${main_ip} (y/n) : " main_ip_ok
#    done
    
#read -p "Transmission username: " uname
#read -p "$uname's Password: " passw



#uname=$1
#admin_username=$4

php_add_head=php
#software_name=${php_add_head}-${uname}
software_name=${php_add_head}-${mydom}
user_root=/home/$uname
user_php=${mydom}/${php_add_head}
#admin_bin_loc=/home/$admin_username/intl
#admin_bin_loc=/home/$admin_username/bin


#### Check Status
USERID=${uname}
STOP_IT=0

/bin/id -u $USERID 2>/dev/null
if [ $? -eq 0 ]; then
   echo "User $USERID already exists."   
else
   echo "UserID : OK"
fi

/bin/id -g $USERID 2>/dev/null
if [ $? -eq 0 ]; then
   echo "Group $USERID already exists."
else
   echo "GroupID : OK"
fi


domain_loc=$user_root/$mydom/$php_add_head/$software_name.conf
if [ -f "$domain_loc" ]
then
	echo "Domain : Error "
        STOP_IT=1
else
	echo "Domain : OK "
   install_type="y"
fi


if [[ $STOP_IT = 1 ]]; then
echo 'Error! Domain already available. Please add new domain and try again.'
exit 1
fi

echo "Starting Install : All OK! "
sleep 3

###########




###########################################

###### EXTRA ADDING 

#####################################################
#####################################################



############################################################
########################## START INSTALL ##################################

# Update system and install required packages
yum -y update
yum -y install gcc gcc-c++ m4 xz make automake curl-devel intltool libtool gettext openssl-devel perl-Time-HiRes wget

yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar epel-release git sudo make cmake GeoIP sed at

yum -y update

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel mailx expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel libgcj gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel libart_lgpl-devel  GeoIP-devel gperftools-devel libicu libicu-devel aspell gmp-devel aspell-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant enchant-devel pam-devel git perl-ExtUtils perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils libc-client libc-client-devel numactl lsof pkgconfig gdbm-devel tk-devel bluez-libs-devel
sudo yum -y install unzip zip rar unrar rsync psmisc syslog-ng-libdbi mediainfo
yum -y install gcc gcc-c++ m4 xz make automake curl-devel intltool libtool gettext openssl-devel perl-Time-HiRes wget


#Create UNIX user and directories for transmission
#encrypt_pass=$(perl -e 'print crypt($ARGV[0], "password")' $passw)
#useradd -m -p $encrypt_pass -g $admin_username $uname

#######
 encrypt_pass=$(perl -e 'print crypt($ARGV[0], "password")' $passw)
## sudo useradd -m -p $encrypt_pass -g $admin_username $uname
sudo useradd -m -p $encrypt_pass $uname
sudo usermod -a -G $uname $uname
############################################# #sudo useradd -m -p $encrypt_pass $uname
 #sudo useradd -m -p $encrypt_pass –g $admin_username $uname
#############################################
 
# sudo usermod -a -G $uname $uname
# sudo usermod -a -G lighttpd $uname

if [[ $uname != $admin_username ]]; then
# sudo usermod -a -G $admin_username $uname
sudo usermod -a -G $uname $admin_username
fi

if [[ $uname = $admin_username ]]; then


echo "
 ## IP Vhost (default)
 
 \$HTTP[\"host\"] == \"$main_ip\" {
    server.document-root = \"/home/admin/ip/html\" 
    server.name = \"$main_ip\"
    accesslog.filename = \"home/logs/log-ip-access.txt\" 
    server.errorfile-prefix = \"/home/admin/ip/error/\"
}
  " > /etc/lighttpd/enabled/1ip.conf

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/add_user.sh -O /etc/addnewuser
chmod 777 /etc/addnewuser

fi

#######


#if [[ $uname != $admin_username ]]; then
#sed -i "s/^\($uname.*\)$/\1$uname,$admin_username/g" /etc/group
#sudo useradd -m -p $encrypt_pass –g $admin_username $uname
#fi

#########
#php_add_head=php
#software_name=${php_add_head}-${mydom}
#user_root=/home/$uname
#user_php=${php_add_head}-${mydom}
#admin_bin_loc=/home/$admin_username/intl
#########

#mkdir -p $user_root/$mydom/{html,$php_add_head,logs}
mkdir -p $user_root/$mydom/{html,$php_add_head}
mkdir -p $user_root/$mydom/$php_add_head/{session,wsdlcache,opcache,log}
#touch $user_root/html/status/php.php

#chmod g+w $user_root


 echo "
 
 \$HTTP[\"host\"] == \"$mydom\" {
    server.document-root = \"$user_root/$mydom/html\" 
    accesslog.filename = \"home/logs/log-$mydom-access.txt\" 
   # fastcgi.map-extensions = (".fpm" => ".php")
   
   #auth.debug = 2
   #auth.backend = \"plain\"
   #auth.backend.plain.userfile = \"/home/admin/.lighttpdpassword\"
   #auth.require = ( \"/admin/\" =>
   #  (
   #   \"method\" => \"basic\",
   #   \"realm\" => \"Password protected area\",
   #   \"require\" => \"user=vivek\"
   #  )
   #)

    auth.backend = \"htpasswd\"
    auth.backend.htpasswd.userfile = \"$user_root/$mydom/.htpasswd\"
    auth.require = ( \"/$admin_username/\" =>
      (
      \"method\"  => \"basic\",
      \"realm\"   => \"Admin Area!  Password Required!\",
      \"require\" => \"user=$admin_username\"
      )
    )
   
    fastcgi.server = ( \".php\" =>
                       (
                          (
			    \"socket\" => \"$user_root/$mydom/$php_add_head/$software_name.sock\",
                            \"broken-scriptfilename\" => \"enable\" 
                          )
                        )
                      )

    server.errorfile-prefix = \"$user_root/$mydom/error/\"

}
  " > /etc/lighttpd/enabled/$mydom.conf

 echo "admin:ZmQSkiPCXoQs2" > $user_root/$mydom/.htpasswd
 chmod 775 $user_root/$mydom/.htpasswd
 
 #echo "admin:pass" > /home/$admin_username/.lighttpdpassword
 #chmod 775 /home/$admin_username/.lighttpdpassword
 
 chown $admin_username:$admin_username /home/$admin_username/.htpasswd
 
###################

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/www -O $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,^.*/run/php-fpm-pool.pid.*,pid = $user_root/$mydom/$php_add_head/$software_name.pid," $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*www-name.*/[$software_name]/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*user-name.*/user = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
#sed -i "s/^.*group-name.*/group = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*group-name.*/group = $admin_username/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,^.*/run/php70-php-fpm.sock.*,listen = $user_root/$mydom/$php_add_head/$software_name.sock," $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*listen-u-name.*/listen.acl_users = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,/user-php-root/,$user_root/$user_php/,g" $user_root/$mydom/$php_add_head/$software_name.conf

sleep 5

#wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/intl -O $admin_bin_loc/$software_name
###sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
#sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/www.conf.*,php_fpm_CONF=$user_root/$mydom/$php_add_head/$software_name.conf," $admin_bin_loc/$software_name
#sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$user_root/$mydom/$php_add_head/$software_name.pid," $admin_bin_loc/$software_name

#wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/intl -O $admin_bin_loc/active/$software_name
###sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
#sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/www.conf.*,php_fpm_CONF=$user_root/$mydom/$php_add_head/$software_name.conf," $admin_bin_loc/active/$software_name
#sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$user_root/$mydom/$php_add_head/$software_name.pid," $admin_bin_loc/active/$software_name

wget https://github.com/munishgaurav5/st/raw/master/ligsetup/replace/intl -O /etc/init.d/$software_name
##sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/www.conf.*,php_fpm_CONF=$user_root/$mydom/$php_add_head/$software_name.conf," /etc/init.d/$software_name
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$user_root/$mydom/$php_add_head/$software_name.pid," /etc/init.d/$software_name

#/etc/init.d/

mkdir -p $user_root/$mydom/html/admin
cd $user_root/$mydom/html/admin

if [[ $uname != $admin_username ]]; then

#wget https://raw.github.com/munishgaurav5/st/master/pFM98.zip -O phpFileManager-0.9.9.zip
wget https://github.com/Th3-822/rapidleech/archive/master.zip
unzip master
#unzip php*
#rm -rf phpF*.zip
##rm -rf master*.zip
#rm -rf LICENSE.html
#mv index.php up.php
mv rapidleech-master test
wget https://github.com/munishgaurav5/st/raw/master/ligsetup/man.php -O up.php
mkdir -p $user_root/$mydom/html/admin/status/
touch $user_root/$mydom/html/admin/status/php.php
fi


 echo '
<?php
echo "<h1>Hello World!</h1>";
echo "<p>Current User ID is: ". posix_getuid();
echo "<p>Current Group ID is: ". posix_getgid();
?>
' > $user_root/$mydom/html/admin/test.php


echo "Done!"



chmod -R 777 /etc/init.d/$software_name
#chown -R $admin_username:$admin_username $admin_bin_loc

#chmod -R 777 $user_root/$mydom/$php_add_head/
###################################################### chown -R $uname:$uname $user_root
chown -R $uname:$admin_username $user_root

chmod 777 $user_root
chmod 777 $user_root/$mydom/
cd $user_root/$mydom/
sudo find . -type f -exec chmod 664 {} \;
sudo find . -type d -exec chmod 775 {} \;

#chmod -R 777 $admin_bin_loc

#chown -R $admin_username:$uname $user_root/logs
#chown -R lighttpd:$uname $user_root/logs

sleep 5

#export PATH="$admin_bin_loc/active:$PATH"
#export PATH="$admin_bin_loc:$PATH"

sleep 2

if [ $restart_now = "y" ]; then
systemctl restart  lighttpd.service
systemctl status  lighttpd.service
fi



echo "Done!!!!!"

#bash $admin_bin_loc/$software_name start

chkconfig --add $software_name
chkconfig --level 345 $software_name on

systemctl daemon-reload

service $software_name start

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
