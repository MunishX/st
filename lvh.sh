#!/bin/bash

#####################################################
#####################################################

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

#read -p "Transmission username: " uname
#read -p "$uname's Password: " passw

software_root=php
software_name=${software_root}-${uname}
domain_root=/home/html/web/
startup_root=/home/html/startup/
user_root=/home/html/users/
##########

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


domain_loc=${startup_root}${mydom}
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


#Create UNIX user and directories for transmission
encrypt_pass=$(perl -e 'print crypt($ARGV[0], "password")' $passw)
useradd -m -p $encrypt_pass $uname

sed -i "s/^\($uname.*\)$/\1$uname,lighttpd/g" /etc/group

mkdir -p $startup_root
chown -R lighttpd:lighttpd $startup_root


mkdir -p $domain_root$mydom/{html,socket,logs}

chmod g+w $domain_root$mydom
chmod -R 777 $domain_root$mydom/socket

chown -R $uname:$uname $domain_root$mydom
chown -R lighttpd:$uname $domain_root$mydom/logs


 echo "
 
 \$HTTP[\"host\"] == \"$mydom\" {
    server.document-root = \"$domain_root$mydom/html\" 
    accesslog.filename = \"$domain_root$mydom/logs/access_log.txt\" 
    fastcgi.map-extensions = (".fpm" => ".php")
    fastcgi.server = ( \".php\" =>
                       (
                          (
			    \"socket\" => \"$domain_root$mydom/socket/$software_name.sock\",
                            \"broken-scriptfilename\" => \"enable\" 
                          )
                        )
                      )
}

  " > /etc/lighttpd/vhosts.d/$mydom.conf

 
 echo '
<?php
echo "<h1>Hello World!</h1>";
echo "<p>Current User ID is: ". posix_getuid();
echo "<p>Current Group ID is: ". posix_getgid();
?>
' > $domain_root$mydom/html/test.php

chown -R $uname:$uname $domain_root$mydom/html

systemctl restart  lighttpd.service

echo "Done!"



##### install all softwares

if [[ $install_type = "y" ]]; then

echo ""
# Install libevent
fi
######################

## PHP-FPM

wget https://github.com/munishgaurav5/st/raw/master/php -O $startup_root$uname
#sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/www.conf.*,php_fpm_CONF=$domain_root$mydom/socket/$software_name.conf," $startup_root$uname
sed -i "s,^.*/etc/opt/remi/php70/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$domain_root$mydom/socket/$software_name.pid," $startup_root$uname
chmod 777 $startup_root$uname

wget https://github.com/munishgaurav5/st/raw/master/www -O $domain_root$mydom/socket/$software_name.conf
sed -i "s,^.*/run/php-fpm-pool.pid.*,pid = $domain_root$mydom/socket/$software_name.pid," $domain_root$mydom/socket/$software_name.conf
sed -i "s/^.*www-name.*/[$software_name]/" $domain_root$mydom/socket/$software_name.conf
sed -i "s/^.*user-name.*/user = $uname/" $domain_root$mydom/socket/$software_name.conf
sed -i "s/^.*group-name.*/group = $uname/" $domain_root$mydom/socket/$software_name.conf
sed -i "s,^.*/run/php70-php-fpm.sock.*,listen = $domain_root$mydom/socket/$software_name.sock," $domain_root$mydom/socket/$software_name.conf
sed -i "s/^.*listen-u-name.*/listen.acl_users = $uname/" $domain_root$mydom/socket/$software_name.conf

echo "Done!!!!!"

bash $startup_root$uname start

