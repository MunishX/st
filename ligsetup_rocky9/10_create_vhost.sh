#!/bin/bash

# CERTBOT CAMMANDS
# > list all timers
# systemctl list-timers
# > list all certificate domains
# sudo certbot certificates 
# > log file path
# tail -n 100 /var/log/letsencrypt/letsencrypt.log
# delete certbot domain to stop renewal
# ls -alh /etc/letsencrypt/renewal/


#ini for each user: php.ini, in systemctl
#/usr/local/php/sbin/php-fpm --fpm-config /etc/php/php-fpm.conf -c /etc/php/php.ini

#change upload max filesize limit in /home/admin/domain.com/php/php_domain.conf
#php_admin_value[memory_limit] = 4096M
#php_admin_value[post_max_size] = 4096M
#php_admin_value[max_file_uploads] = 4096M
#;php_admin_value[upload_max_filesize] = 4096M


# UMASK NEW
# sed -i "s,^.*umask 0.*,umask 002,g" /etc/bashrc

#### PHP CONFIG
#PHP_V='php70'
#PHP_V='php71'
#PHP_V='php74'
# PHP_V not required in this page

############################### ADDED START
#main_ip="$(hostname -I)"
get_ip="$(ip a | grep "scope global" | grep -Po '(?<=inet )[\d.]+' | tr '\n' ' ' | awk '{print $1}')"
get_ip=${get_ip//[[:blank:]]/}

# Take input for username and password
uname=$1
   while [[ $uname = "" ]]; do # to be replaced with regex
       read -p "VHost username: " uname
    done

passw=$2
   while [[ $passw = "" ]]; do # to be replaced with regex
       read -p "$uname's Password: " passw
    done

DOMAIN_SUB_PART=$3
echo ""
   while [[ $DOMAIN_SUB_PART = "" ]]; do # to be replaced with regex
       read -p "Sub-Domain Part (ignore for www, ex:host) : " DOMAIN_SUB_PART
    done

DOMAIN_MAIN_PART=$4
echo ""
   while [[ $DOMAIN_MAIN_PART = "" ]]; do # to be replaced with regex
       read -p "Domain Name (domain.com): " DOMAIN_MAIN_PART
    done

#mydom=$3
#   while [[ $mydom = "" ]]; do # to be replaced with regex
#       read -p "$uname's Domain: " mydom
#    done

admin_username=$5
   while [[ $admin_username = "" ]]; do # to be replaced with regex
       read -p "ADMIN USERNAME: " admin_username
    done

if [[ $4 = "" ]]; then 
   Setup_IPV6='n'  
else
   Setup_IPV6=$6
fi

#Setup_IPV6=$6
   while [[ $Setup_IPV6 = "" ]]; do # to be replaced with regex
       read -p "Enable ipv6 for lighttpd (y/n): " Setup_IPV6
    done

restart_now=$7
   while [[ $restart_now = "" ]]; do # to be replaced with regex
       read -p "Reload Lighttpd after Finish (y/n) : " restart_now
    done

if [[ $4 = "" ]]; then 
   set_ip_host='n'  
else
   set_ip_host=$8
fi

#set_ip_host=$8
   while [[ $set_ip_host = "" ]]; do # to be replaced with regex
       read -p "Also set IP vhost (y/n) : " set_ip_host
    done

if [[ $set_ip_host = "y" ]] || [[ $set_ip_host = "Y" ]]; then
   main_ip=$9
   while [[ $main_ip = "" ]]; do # to be replaced with regex
       read -p "SERVER MAIN IP is  ( ex ${get_ip} ) : " main_ip
   done
   main_ip=${main_ip//[[:blank:]]/}
   echo "Final Main IP is : $main_ip"
else
   echo "IP check Skipping... "
   main_ip=blank
fi

DOMAIN_SUB_PART=${DOMAIN_SUB_PART//[[:blank:]]/}
DOMAIN_MAIN_PART=${DOMAIN_MAIN_PART//[[:blank:]]/}
mydom=''
mydom2=''
mydomwww='www'
mywwwdommatch=''

if [[ $DOMAIN_SUB_PART = "" ]]; then
mydom=${DOMAIN_MAIN_PART}
mydom2=${mydomwww}.${DOMAIN_MAIN_PART}
mywwwdommatch=''
else
mydom=${DOMAIN_SUB_PART}.${DOMAIN_MAIN_PART}
mydom2=''
mywwwdommatch='(www.)?'
fi

if [[ $4 = "" ]]; then 
   Final_Confirm=''  
else
   Final_Confirm='y'
fi
echo ""
   while [[ $Final_Confirm = "" ]]; do # to be replaced with regex
       read -p "Please confirm domain name ${mydom} ${mydom2} (y/n): " Final_Confirm
    done

if [ $Final_Confirm != "y" ]; then 
   echo "Aborting....!... Try Again!"
   exit 1  
fi

    
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
server_stat=''
#####################################################
#####################################################



############################################################
########################## START INSTALL ##################################

# Update system and install required packages
#yum -y update
#yum -y install gcc gcc-c++ m4 xz make automake curl-devel intltool libtool gettext openssl-devel perl-Time-HiRes wget

#yum -y update
#yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar epel-release git sudo make cmake GeoIP sed at

#yum -y update

#sudo yum -y groupinstall "Development Tools"
#sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel mailx expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel libgcj gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel libart_lgpl-devel  GeoIP-devel gperftools-devel libicu libicu-devel aspell gmp-devel aspell-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant enchant-devel pam-devel git perl-ExtUtils perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils libc-client libc-client-devel numactl lsof pkgconfig gdbm-devel tk-devel bluez-libs-devel
#sudo yum -y install unzip zip rar unrar rsync psmisc syslog-ng-libdbi mediainfo
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

if [[ $set_ip_host = 'y' ]]; then

sudo usermod -a -G lighttpd $admin_username
chown $admin_username:$admin_username /home

echo "
 ## IP Vhost (default)
 
 \$HTTP[\"host\"] == \"$main_ip\" {
    server.document-root = \"/home/admin/ip/html\" 
    server.name = \"$main_ip\"
    accesslog.filename = \"/home/lighttpd/log-ip-access.txt\" 
    server.errorfile-prefix = \"/home/admin/ip/error/\"
 #   evasive.max-conns-per-ip = 3
    server.kbytes-per-second=1024
    connection.kbytes-per-second=512
    
}
  " > /etc/lighttpd/enabled/1ip.conf


# CERTBOT install certbot - auto mode for lighttpd 

echo "Setting up Certbot Auto HTTPS.."
sudo yum install epel-release -y
sudo yum install certbot -y

sed -i "s/^POST_HOOK.*/POST_HOOK=\"--post-hook 'systemctl reload lighttpd'\"/g" /etc/sysconfig/certbot

systemctl daemon-reload
systemctl enable certbot-renew.timer
systemctl start certbot-renew.timer
systemctl list-timers
systemctl status certbot-renew.timer

echo "
 ## Certbot Cert-only acme-challenge (default)

server.modules += (
    \"mod_alias\"
)

alias.url += (
    \"/.well-known/\" => \"/home/lighttpd/acme-challenge/.well-known/\"
)

  " > /etc/lighttpd/enabled/1certbot.conf

echo '
   server.modules += ( "mod_openssl" )
   $SERVER["socket"] == "*:443" {
     ssl.engine  = "enable"
     ssl.privkey= "/etc/letsencrypt/live/'${$mydom}'/privkey.pem"
     ssl.pemfile= "/etc/letsencrypt/live/'${$mydom}'/fullchain.pem"
     ssl.openssl.ssl-conf-cmd = ("MinProtocol" => "TLSv1.2") # (recommended to accept only TLSv1.2 and TLSv1.3)
     ssl.cipher-list = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
#     ssl.ec-curve = "secp384r1"
     ssl.honor-cipher-order = "disable"
     ssl.disable-client-renegotiation = "enable"
     setenv.add-response-header = ( "Strict-Transport-Security" => "max-age=31536000")
   }
   
' > /etc/lighttpd/enabled/1ssl_ipv4.conf
if [[ $Setup_IPV6 = 'y' ]]; then
echo '
   server.modules += ( "mod_openssl" )
   $SERVER["socket"] == "[::]:443" {
     ssl.engine  = "enable"
     ssl.privkey= "/etc/letsencrypt/live/'${$mydom}'/privkey.pem"
     ssl.pemfile= "/etc/letsencrypt/live/'${$mydom}'/fullchain.pem"
     ssl.openssl.ssl-conf-cmd = ("MinProtocol" => "TLSv1.2") # (recommended to accept only TLSv1.2 and TLSv1.3)
     ssl.cipher-list = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
#     ssl.ec-curve = "secp384r1"
     ssl.honor-cipher-order = "disable"
     ssl.disable-client-renegotiation = "enable"
     setenv.add-response-header = ( "Strict-Transport-Security" => "max-age=31536000")
   }

' > /etc/lighttpd/enabled/1ssl_ipv6.conf
echo '
   $SERVER["socket"] == "[::]:80" {
   }
   
' > /etc/lighttpd/enabled/1ipv6.conf

fi

echo '
server.modules += ("mod_setenv", "mod_redirect")
$HTTP["scheme"] == "http" {
$HTTP["remote-ip"] != "127.0.0.1" {
$HTTP["remote-ip"] != "[::1]" {
$HTTP["host"] != "__MAIN_IP__" {
$HTTP["url"] !~ "^/.well-known/" {
    # Follows https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Upgrade-Insecure-Requests
    # Adding the header only works if mod_setenv is loaded before mod_redirect in lighttpd.conf!
    # (See https://redmine.lighttpd.net/issues/1895)
    setenv.add-response-header = ("Vary" => "Upgrade-Insecure-Requests")
    $REQUEST_HEADER["Upgrade-Insecure-Requests"] == "1" {
        url.redirect = ("" => "https://${url.authority}${url.path}${qsa}")
        url.redirect-code = 308
    }
}
}
}
}
}

' > /etc/lighttpd/enabled/1http_to_https.conf

sed -i "s/__MAIN_IP__/$main_ip/" /etc/lighttpd/enabled/1http_to_https.conf


#echo '#!/bin/sh
##cat $RENEWED_LINEAGE/privkey.pem $RENEWED_LINEAGE/cert.pem > $RENEWED_LINEAGE/ssl.pem
#echo "CERTBOT SSL Certificate updated for $RENEWED_LINEAGE and now re-loading lighttpd server..."
#systemctl reload lighttpd
#' > /home/lighttpd/renew-hook.sh


# sudo certbot certonly --webroot -w /home/lighttpd/acme-challenge/ --preferred-challenges http --domain host.fastserver.me --email munishgaurav5@gmail.com --agree-tos --no-eff-email
# sudo certbot certonly --webroot -w /home/lighttpd/acme-challenge/ --preferred-challenges http --domain ${DOMAIN} --email ${EMAIL} --agree-tos --no-eff-email
# export RENEWED_LINEAGE=/etc/letsencrypt/live/host.fastserver.me && bash /home/lighttpd/renew-hook.sh

# --pre-hook "service nginx stop" --post-hook "service nginx start"
#crontab -l | { cat; echo "0 0,12 * * *  certbot renew --deploy-hook /home/lighttpd/renew-hook.sh --quiet"; } | crontab -

# /usr/lib/systemd/system/certbot-renew.timer
# /usr/lib/systemd/system/certbot-renew.service
# systemctl start certbot-renew.timer
# systemctl list-timers

# #ExecStart=/usr/bin/certbot renew --noninteractive --no-random-sleep-on-renew $PRE_HOOK $POST_HOOK $RENEW_HOOK $DEPLOY_HOOK $CERTBOT_ARGS
#ExecStart=/usr/bin/certbot renew --noninteractive --no-random-sleep-on-renew --deploy-hook "datetime > /tmp/last_certbot_check.txt, systemctl reload lighttpd, systemctl restart postfix” --quiet

# nano /var/log/letsencrypt/letsencrypt.log

mkdir -p /home/lighttpd/acme-challenge/
chmod 777 /home/lighttpd/acme-challenge/
chown -R lighttpd:admin /home/lighttpd/acme-challenge/
#chown -R lighttpd:admin /home/lighttpd/renew-hook.sh



mkdir -p /home/admin/ip/{html,error,ssl}
chmod -R 777 /home/admin/ip/

mkdir -p /home/admin/bin/
chmod -R 777 /home/admin/bin/

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/add_user.sh -O /usr/bin/addnewuser
chmod 777 /usr/bin/addnewuser

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/10_create_vhost.sh -O /usr/bin/addnewuser_create_vhost
chmod 777 /usr/bin/addnewuser_create_vhost

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/12_tmm.sh -O /usr/bin/addnewuser_tmm
chmod 777 /usr/bin/addnewuser_tmm

#server_stat='
#server.modules += ( "mod_status" )
#  status.status-url          = "/admin/server-status"
#  status.config-url          = "/admin/server-config"
#  status.statistics-url      = "/admin/server-statistics"
#  status.enable-sort         = "enable"  
#  '
  
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
mkdir -p $user_root/$mydom/{html,error,ssl,$php_add_head}
mkdir -p $user_root/$mydom/$php_add_head/{session,savedsession,wsdlcache,opcache,log}
#touch $user_root/html/status/php.php

#chmod g+w $user_root

 #$HTTP["host"] =~ "^(www\.)?url.com$" {
 echo "

\$HTTP[\"host\"] =~ \"^${mywwwdommatch}${mydom}\$\" {
 #\$HTTP[\"host\"] =~ \"^(www.)?$mydom\$\" {
 #\$HTTP[\"host\"] == \"$mydom\" {
    server.document-root = \"$user_root/$mydom/html\" 
    accesslog.filename = \"/home/lighttpd/log-$mydom-access.txt\" 
 #   evasive.max-conns-per-ip = 200
    #server.kbytes-per-second=97280
    #connection.kbytes-per-second=51200
   # fastcgi.map-extensions = (".fpm" => ".php")
     ssl.privkey= \"/etc/letsencrypt/live/$mydom/privkey.pem\"
     ssl.pemfile= \"/etc/letsencrypt/live/$mydom/fullchain.pem\"

   #$server_stat

  $HTTP["url"] =~ "^/host/" {
    auth.backend = \"htpasswd\"
    auth.backend.htpasswd.userfile = \"$user_root/$mydom/.htpasswd\"
    auth.require = ( \"/host/\" =>
      (
      \"method\"  => \"basic\",
      \"realm\"   => \"Admin Area!  Password Required!\",
      \"require\" => \"user=admin\"
      )
    )
  }
   
   #     php file add-    header( "X-LIGHTTPD-send-file: " . $file_on_harddisk);
    fastcgi.server = ( \".php\" =>
                       (
                          (
			    \"socket\" => \"$user_root/$mydom/$php_add_head/$software_name.sock\",
                            \"broken-scriptfilename\" => \"enable\",
			    \"allow-x-send-file\" => \"enable\"
                          )
                        )
                      )

    server.errorfile-prefix = \"$user_root/$mydom/error/\"
    
url.rewrite-once = (
\"^/host/status/cron/src/assets/(.*)\" => \"\",
\"^/host/status/cron/src/(.*)\" => \"/host/status/cron/src/index.php\",
\"^/account/?(.*)\" => \"\",
\"^/admin/?(.*)\" => \"\",
\"^/big/?(.*)\" => \"\",
\"^/free/?(.*)\" => \"\",
\"^/host/?(.*)\" => \"\",
\"^/member/?(.*)\" => \"\",
\"^/p/?(.*)\" => \"\",
\"^/premium/?(.*)\" => \"\",
\"^/test/?(.*)\" => \"\",
\"^/torrentleech/?(.*)\" => \"\",
\"^/vip/?(.*)\" => \"\",
\"^/rar/?(.*)\" => \"\"
)

}
  " > /etc/lighttpd/enabled/$mydom.conf

 echo "admin:ZmQSkiPCXoQs2" > $user_root/$mydom/.htpasswd
 chmod 775 $user_root/$mydom/.htpasswd
 
 #echo "admin:pass" > /home/$admin_username/.lighttpdpassword
 #chmod 775 /home/$admin_username/.lighttpdpassword
 
 #chown $admin_username:$admin_username /home/$admin_username/.htpasswd
 chown $admin_username:$admin_username $user_root/$mydom/.htpasswd

# certbot auto ssl for website
 
if [[ $mydom2 = "" ]]; then
   echo "User $USERID already exists."   
   sudo certbot certonly --webroot -w /home/lighttpd/acme-challenge/ --preferred-challenges http --domain $mydom --email admin@${mydom} --agree-tos --no-eff-email
else
   echo "UserID : OK"
   sudo certbot certonly --webroot -w /home/lighttpd/acme-challenge/ --preferred-challenges http --domain $mydom --domain $mydom2 --email admin@${mydom} --agree-tos --no-eff-email
fi
###################

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/www -O $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,^.*/run/php-fpm-pool.pid.*,pid = $user_root/$mydom/$php_add_head/$software_name.pid," $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*www-name.*/[$software_name]/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*user-name.*/user = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
#sed -i "s/^.*group-name.*/group = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*group-name.*/group = $admin_username/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,^.*/run/php-php-fpm.sock.*,listen = $user_root/$mydom/$php_add_head/$software_name.sock," $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s/^.*listen-u-name.*/listen.acl_users = $uname/" $user_root/$mydom/$php_add_head/$software_name.conf
sed -i "s,/user-php-root/,$user_root/$user_php/,g" $user_root/$mydom/$php_add_head/$software_name.conf

sleep 5

#wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/intl -O /etc/init.d/$software_name
###sed -i "s/^.*php-fpm-bin.*/php_fpm_BIN=php-$uname/" $startup_root$uname
#sed -i "s,^.*/etc/opt/remi/php/php-fpm.d/www.conf.*,php_fpm_CONF=$user_root/$mydom/$php_add_head/$software_name.conf," /etc/init.d/$software_name
#sed -i "s,^.*/etc/opt/remi/php/php-fpm.d/php-fpm.pid.*,php_fpm_PID=$user_root/$mydom/$php_add_head/$software_name.pid," /etc/init.d/$software_name

wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/phpintl -O /usr/lib/systemd/system/$software_name.service
sed -i "s,^.*php_config_file.conf.*,ExecStart=/usr/bin/php-fpm --fpm-config=$user_root/$mydom/$php_add_head/$software_name.conf --nodaemonize," /usr/lib/systemd/system/$software_name.service
chmod 777 /usr/lib/systemd/system/$software_name.service

# /etc/systemd/system/ in ubuntu system
#/etc/init.d/

mkdir -p $user_root/$mydom/html/host
cd $user_root/$mydom/html/host

#if [[ $uname != $admin_username ]]; then

#wget https://raw.github.com/munishgaurav5/st/master/pFM98.zip -O phpFileManager-0.9.9.zip
wget https://github.com/Th3-822/rapidleech/archive/master.zip
unzip master
#unzip php*
#rm -rf phpF*.zip
##rm -rf master*.zip
#rm -rf LICENSE.html
#mv index.php up.php
mv rapidleech-master test
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/man.php -O up.php
wget https://github.com/munishgaurav5/st/raw/master/ligsetup_rocky9/replace/man2.php -O up2.php
wget https://github.com/MunishX/st/raw/master/ligsetup_rocky9/replace/PHPMailer.zip
unzip PHPMailer.zip
rm -rf PHPMailer.zip
mkdir -p $user_root/$mydom/html/host/
touch $user_root/$mydom/html/host/php.php
#fi


 echo '
<?php
echo "<h1>Hello World!</h1>";
echo "<p>Current User ID is: ". posix_getuid();
echo "<p>Current Group ID is: ". posix_getgid();
?>
' > $user_root/$mydom/html/test.php


echo "Done!"




#chown -R $admin_username:$admin_username $admin_bin_loc

#chmod -R 777 $user_root/$mydom/$php_add_head/
###################################################### chown -R $uname:$uname $user_root
chown -R $uname:$admin_username $user_root
#chown -R $uname:$admin_username $user_root

chmod 777 $user_root
chmod 777 $user_root/$mydom/
#cd $user_root/$mydom/
#sudo find . -type f -exec chmod 664 {} \;
#sudo find . -type d -exec chmod 775 {} \;

#chmod -R 777 $admin_bin_loc

#chown -R $admin_username:$uname $user_root/logs
chown -R lighttpd:$admin_username /home/lighttpd

sleep 5

#export PATH="$admin_bin_loc/active:$PATH"
#export PATH="$admin_bin_loc:$PATH"

#sleep 2

if [ $restart_now = "y" ]; then
#systemctl restart  lighttpd.service
#systemctl status  lighttpd.service
service lighttpd reload
fi


echo "Done!!!!!"

#bash $admin_bin_loc/$software_name start
#chmod -R 777 /etc/init.d/$software_name
#chkconfig --add $software_name
#chkconfig --level 345 $software_name on


systemctl daemon-reload
systemctl enable $software_name 

#service $software_name start
#service $software_name status
systemctl start $software_name
systemctl status $software_name --no-pager
sleep 5
systemctl reload $software_name
systemctl status $software_name --no-pager
sleep 5
systemctl restart $software_name
systemctl status $software_name --no-pager

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
