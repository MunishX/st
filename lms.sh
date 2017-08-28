#!/bin/bash
echo "MAINTAINER XYZ"
sleep 2

#######################################
#cd /tmp
#wget https://raw.github.com/munishgaurav5/st/master/ms.sh
#chmod 777 ms.sh
#./ms.sh

#cd /tmp
#wget https://raw.github.com/munishgaurav5/st/master/dk.sh
#chmod 777 dk.sh
#./dk.sh

#######################################

if [[ "$(id -u)" != 0 ]]; then
    echo "Sorry, you need to run this as root"
    exit 1
fi

if [[ -e /etc/debian_version ]]; then
    DISTRO="Debian"
    echo "This distribution type/version is not supported"
    exit 1
elif [[ -f /etc/centos-release ]]; then
    #RELEASE=$(rpm -q --queryformat '%{VERSION}' centos-release)
    #DISTRO="CentOS${RELEASE}"
    DISTRO="CentOS"
    echo "OS : $DISTRO    OK "
else
    echo "This distribution type/version is not supported"
    exit 1
fi

###########
SRV_MAIL_IP=$1
WEBMAIL_HOST=$2
WEBMAIL_DOMAIN=$3
SQL_ROOT_PASS=$4

if [[ $SRV_MAIL_IP != "" ]]; then
   IP_CORRECT="y"
fi 

##### #####

if [[ $IP_CORRECT != "y" ]]; then
IP_CORRECT=   

MAIN_IP="$(hostname -I)"
# Remove blank space
MAIN_IP=${MAIN_IP//[[:blank:]]/}

echo ""
echo ""

   while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p " SERVER MAIN IP is '${MAIN_IP}' (y/n) : " IP_CORRECT
       #$MAIN_IP
    done

if [ $IP_CORRECT != "y" ]; then
   read -p "SERVER IP : " MAIN_IP
   #exit 1
   
      IP_CORRECT=
      while [[ $IP_CORRECT = "" ]]; do # to be replaced with regex       
       read -p "SERVER IP is ${MAIN_IP} (y/n) : " IP_CORRECT
       #$MAIN_IP
      done
fi


if [ $IP_CORRECT != "y" ]; then
   #read -p "SERVER IP : " MAIN_IP
   echo "Error!... Try Again!"
   exit 1
fi

SRV_MAIL_IP=${MAIN_IP}
fi
#######

##### #####
#   while [[ $SRV_MAIL_IP = "" ]]; do # to be replaced with regex
#        read -p "Main Server IP (e.g. 123.345.567.789): " SRV_MAIL_IP
#    done
    
   while [[ $WEBMAIL_HOST = "" ]]; do # to be replaced with regex
        read -p "WEBMAIL HOST (e.g. mail): " WEBMAIL_HOST
    done
   while [[ $WEBMAIL_DOMAIN = "" ]]; do # to be replaced with regex
        read -p "WEBMAIL DOMAIN (e.g. website.com): " WEBMAIL_DOMAIN
    done
   while [[ $SQL_ROOT_PASS = "" ]]; do # to be replaced with regex
        read -p "MYSQL ROOT Password (e.g. !@#qweRTY%): " SQL_ROOT_PASS
    done
    
#    while ! [[ $BLOCK_SUBNET =~ ^[0-9]+$ ]]; do
#        read -p "Subnet for your block (e.g. if it's /56, input 56): " BLOCK_SUBNET
#    done

#    while [[ $BLOCK_DUID = "" ]]; do # to be replaced with regex
#        read -p "Associated DUID (e.g. 00:03:00:00:34:b0:0c:47:4a:0e): " BLOCK_DUID
#    done

    echo "Working..."
sleep 3

#######################################
## <Variabile de schimbat> ###

#SRV_MAIL_IP=192.168.2.162
#SQL_ROOT_PASS='change-SQL_change'
#WEBMAIL_HOST='mail'
#WEBMAIL_DOMAIN='cmail.cf'

HOSTNAME_WEB=${WEBMAIL_HOST}.${WEBMAIL_DOMAIN}
VH_ROUNCUBE='roundcube.'${WEBMAIL_DOMAIN}
VH_POSTFIXADMIN='postfix.'${WEBMAIL_DOMAIN}
SRV_ALIAS='webmail.'${WEBMAIL_DOMAIN}
MAIL_ADMIN='mail@'${WEBMAIL_DOMAIN}


USR_ID=30791
#
POSTFIX_USER='vmail'
POSTFIX_PASS='postfixpass'
POSTFIX_SQL_DB='postfix_mailDB'
POSTFIX_MAIL_LOCATION=/var/vmail
#
ROUNDCUBE_USER='rcuser'
ROUNDCUBE_PASS='rcpass'
ROUNDCUBE_DB='roundcube_lDB'
#

# Update program links
WEB_LATEST_POSTFIXADM='https://raw.github.com/munishgaurav5/st/master/pfa302.tar.gz'
## </Variabile de schimbat> ###


#######################
## <Variabile de schimbat> ###
#
#SRV_MAIL_IP=192.168.2.162
#USR_ID=30791
#
#SQL_ROOT_PASS='change-SQL_change'
#POSTFIX_USER='postfixuser'
#POSTFIX_PASS='postfixpass'
#POSTFIX_SQL_DB='postfix_mailDB'
#POSTFIX_MAIL_LOCATION=/var/vmail
#
#ROUNDCUBE_USER='rcuser'
#ROUNDCUBE_PASS='rcpass'
#ROUNDCUBE_DB='roundcube_lDB'
#
#HOSTNAME_WEB=mail.euroweb.ro
#VH_ROUNCUBE='roundcube.euroweb.ro'
#VH_POSTFIXADMIN='postfix.euroweb.ro'
#SRV_ALIAS='webmail.euroweb.ro'
#MAIL_ADMIN='mail@localhost'

# Update program links
#WEB_LATEST_POSTFIXADM='https://raw.github.com/munishgaurav5/st/master/pfa302.tar.gz'

## </Variabile de schimbat> ###
############### REQ SOFTWARES INSTALL ##################

hostnamectl set-hostname $HOSTNAME_WEB
hostname

echo "$SRV_MAIL_IP $HOSTNAME_WEB $WEBMAIL_HOST" >> /etc/hosts


cd /tmp


yum -y update
yum -y install nano wget curl net-tools lsof bzip2 zip unzip rar unrar epel-release git sudo make cmake GeoIP sed at

yum -y update

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc gcc-c++ pcre pcre-devel zlib zlib-devel mailx expect imake lsof autoconf nc ca-certificates libedit-devel make automake expat-devel perl-libwww-perl perl-Crypt-SSLeay perl-Net-SSLeay tree virt-what cmake openssl-devel net-tools systemd-devel libdb-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed patch sysstat libtool bind-utils libXext-devel cyrus-sasl-devel glib2 glib2-devel openssl ncurses-devel bzip2 bzip2-devel flex bison libcurl-devel which libevent libevent-devel libgcj gettext-devel vim-minimal nano cairo-devel libxml2-devel libxml2 libpng-devel freetype freetype-devel libart_lgpl-devel  GeoIP-devel gperftools-devel libicu libicu-devel aspell gmp-devel aspell-devel libtidy libtidy-devel readline-devel iptables* coreutils libedit-devel enchant enchant-devel pam-devel git perl-ExtUtils perl-ExtUtils-MakeMaker perl-Time-HiRes openldap openldap-devel curl curl-devel diffutils libc-client libc-client-devel numactl lsof pkgconfig gdbm-devel tk-devel bluez-libs-devel
sudo yum -y install unzip zip rar unrar rsync psmisc syslog-ng-libdbi mediainfo

echo ""
echo ""
echo ""
echo "Step 1 auto install"
sleep 10
echo ""
echo ""
echo ""
echo ""
########################################################


### install ##################################################
# add mail user
groupadd -g $USR_ID $POSTFIX_USER
useradd -g $USR_ID -u $USR_ID -d $POSTFIX_MAIL_LOCATION $POSTFIX_USER -s /sbin/nologin -c "virtual postfix user"

# install_POSTFIX+VDA-patched
yum remove -y postfix
yum localinstall -y /home/ansible/postfix*.rpm

# _install_preparation
yum install -y epel-release 
# 8 packages to install
#yum install -y amavisd-new clamav-server-systemd clamav-update dovecot dovecot-mysql dovecot-pigeonhole httpd pypolicyd-spf
yum install -y amavisd-new clamav-server-systemd clamav-update dovecot dovecot-mysql dovecot-pigeonhole pypolicyd-spf
# 8 packages to install
#yum install -y mariadb mariadb-server mod_ssl ntp php php-imap php-mysql php-xml
# 8 packages to install
#yum install -y opendkim php-gd php-intl php-ldap php-mbstring php-mcrypt roundcubemail spamassassin
yum install -y opendkim roundcubemail spamassassin
# 3 packages to install #security test last
#yum install -y mod_security mod_security_crs redhat-lsb-submod-security 
## install_PostfixAdmin #
#curl -s $WEB_LATEST_POSTFIXADM --insecure | tar zxvf - -C /var/www/html/
#mv /var/www/html/postfixadmin-*/ /var/www/html/postfixadmin
#chown apache:apache -R /var/www/html/postfixadmin
cd /tmp
rm -rf postfixadmi*
wget $WEB_LATEST_POSTFIXADM -O postfixadmin-302.tar.gz
tar zvxf postfixadmin-*.tar.gz
rm -rf /home/html/postfixadmi*

mkdir -p /home/html/postfixadmin
mv postfixadmin-*/* /home/html/postfixadmin

chown lighttpd:lighttpd -R /home/html/postfixadmin


echo ""
echo ""
echo ""
echo "Step 2 postfixadmin"
sleep 10
echo ""
echo ""
echo ""
echo ""

# Configure email-services ###############################
# set timezone
#sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Bucharest\"/" /etc/php.ini 

# enable @Boot_Services"
systemctl enable postfix dovecot httpd mariadb amavisd clamd@amavisd spamassassin opendkim

# conf_RoundCube ###
cp /etc/roundcubemail/config.inc.php.sample /etc/roundcubemail/config.inc.php
chown root:lighttpd /etc/roundcubemail/config.inc.php
echo "\$rcmail_config['force_https'] = true;" >> /etc/roundcubemail/config.inc.php
echo "\$rcmail_config['preview_pane'] = true;" >> /etc/roundcubemail/config.inc.php
echo "\$config['login_rate_limit'] = 3;" >> /etc/roundcubemail/config.inc.php
echo "\$rcmail_config['timezone'] = 'auto'; " >> /etc/roundcubemail/config.inc.php
# plain password compatible with crypt field#
echo "\$rcmail_config['imap_auth_type'] = 'LOGIN';" >> /etc/roundcubemail/config.inc.php
# setup user/pass/db > roundcube
sed -i "s|^\(\$config\['db_dsnw'\] =\).*$|\1 \'mysqli://${ROUNDCUBE_USER}:${ROUNDCUBE_PASS}@localhost/${ROUNDCUBE_DB}\';|" /etc/roundcubemail/config.inc.php
# add quota status in roundcube warn 90%
mkdir -p /usr/share/roundcubemail/plugins/quota_notify
cat <<EOT >> /usr/share/roundcubemail/plugins/quota_notify/quota_notify.php
<?php
class quota_notify extends rcube_plugin {
  public \$task = 'mail';
  function init() {
    \$this->add_hook('quota', array(\$this, 'quota_warning_message'));
  }
  function quota_warning_message(\$args) {
    \$rcmail = rcmail::get_instance();
    if(\$args['percent'] > 90) {
      \$rcmail->output->show_message('Warning. <br> Mailbox is almost full: ' . \$args['percent'] . '%. <br> Clean emailbox or increase mailbox size. ', 'warning');
    }
  }
}
?>
EOT

#add managesieve plugin to roundcube
sed -i "s|^\(\$config\['plugins'\] =\).*$|\1 array('managesieve', 'quota_notify\',|" /etc/roundcubemail/config.inc.php
cp /usr/share/roundcubemail/plugins/managesieve/config.inc.php.dist /usr/share/roundcubemail/plugins/managesieve/config.inc.php
## sieve settings
sed -i "s|^\(\$config\['managesieve_auth_type'\] =\).*$|\1 \'LOGIN\';|" /usr/share/roundcubemail/plugins/managesieve/config.inc.php
sed -i "s|^\(\$config\['managesieve_vacation'\] =\).*$|\1 \'2\';|" /usr/share/roundcubemail/plugins/managesieve/config.inc.php
sed -i "s|^\(\$config\['managesieve_vacation_interval'\] =\).*$|\1 \'1\';|" /usr/share/roundcubemail/plugins/managesieve/config.inc.php

# conf_PostfixAdmin ###
sed -i "s|^\(\$CONF\['configured'\] =\).*$|\1 \ true\;|" /home/html/postfixadmin/config.inc.php
sed -i "s|^\(\$CONF\['database_user'\] =\).*$|\1 \'$POSTFIX_USER\';|" /home/html/postfixadmin/config.inc.php
sed -i "s|^\(\$CONF\['database_password'\] =\).*$|\1 \'$POSTFIX_PASS\';|" /home/html/postfixadmin/config.inc.php
sed -i "s|^\(\$CONF\['database_name'\] =\).*$|\1 \'$POSTFIX_SQL_DB\';|" /home/html/postfixadmin/config.inc.php
# user mailbox quota=2056MB
sed -i "s|^\(\$CONF\['maxquota'\] =\).*$|\1 \'2056\';|" /home/html/postfixadmin/config.inc.php
sed -i "s|^\(\$CONF\['quota'\] =\).*$|\1 \'YES\';|" /home/html/postfixadmin/config.inc.php
# domain quota (default enabled)
#sed -i "s|^\(\$CONF\['domain_quota'\] =\).*$|\1 \'NO\';|" /var/www/html/postfixadmin/config.inc.php

# _create SSL-Certs ###
#mkdir -p /etc/httpd/ssl/
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/$HOSTNAME_WEB.key -out /etc/httpd/ssl/$HOSTNAME_WEB.crt <<EOF  
#RO
#Bucharest
#Bucharest
#$HOSTNAME_WEB
#$HOSTNAME_WEB-IT
#$HOSTNAME_WEB
#$MAIL_ADMIN
#EOF

echo ""
echo ""
echo ""
echo "Step 3 RC and Postfixadmin config"
sleep 10
echo ""
echo ""
echo ""
echo ""


cd /tmp
rm -rf /opt/letsencryp*
rm -rf /etc/letsencryp*

yum -y install git bc
git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
#/opt/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos --email myemail@$WEBMAIL_DOMAIN -d $WEBMAIL_DOMAIN -d www.$WEBMAIL_DOMAIN -d $VH_ROUNCUBE -d $VH_POSTFIXADMIN -d $SRV_ALIAS
/opt/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos --email myemail@$WEBMAIL_DOMAIN -d $HOSTNAME_WEB -d $VH_ROUNCUBE -d $VH_POSTFIXADMIN -d $SRV_ALIAS
#/opt/letsencrypt/letsencrypt-auto renew

chown -R root:root /etc/letsencrypt/live/

#/etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem/privkey.pem
#fullchain.pem
#privkey.pem
#cert.pem
#chain.pem

#
echo ""
echo ""
echo ""
echo "Step 4 ssl"
sleep 10
echo ""
echo ""
echo ""
echo ""

# _config: DKIM ###
mkdir -p /etc/opendkim/keys/
#/usr/sbin/opendkim-genkey -D /etc/opendkim/keys/$HOSTNAME_WEB/ -d $HOSTNAME_WEB -s dkim_selector
chown -R opendkim:opendkim /etc/opendkim/keys/
#echo "*@$HOSTNAME_WEB dkim_selector._domainkey.$HOSTNAME_WEB" >> /etc/opendkim/SigningTable
#echo "*dkim_selector._domainkey.$HOSTNAME_WEB $HOSTNAME_WEB:dkim_selector:/etc/opendkim/keys/$HOSTNAME_WEB/dkim_selector" >> /etc/opendkim/KeyTable
#mv /etc/opendkim/keys/$HOSTNAME_WEB/dkim_selector.private /etc/opendkim/keys/$HOSTNAME_WEB/dkim_selector
echo "localhost" >> /etc/opendkim/TrustedHosts
echo "$HOSTNAME_WEB" >> /etc/opendkim/TrustedHosts
echo "$SRV_MAIL_IP" >> /etc/opendkim/TrustedHosts

#
cat <<EOT > /etc/opendkim.conf
## opendkim.conf -- configuration file for OpenDKIM filter
AutoRestart             Yes
AutoRestartRate         10/1h
Canonicalization        relaxed/simple
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
LogWhy                  Yes
Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256
SigningTable            refile:/etc/opendkim/SigningTable
Socket                  inet:8891@localhost
Syslog                  Yes
SyslogSuccess           Yes
TemporaryDirectory      /var/tmp
UMask                   022
UserID                  opendkim:opendkim
EOT

# _config_HTTPD=(vh_roundcube+vh_postfixadmin)  ###
#rm -f /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/roundcubemail.conf /etc/httpd/conf.d/autoindex.conf
#echo "Listen 443" >> /etc/httpd/conf/httpd.conf
#echo "ServerName $HOSTNAME_WEB" >> /etc/httpd/conf/httpd.conf
#cat <<EOT >> /etc/httpd/conf.d/vh1_postfix-roundcube.conf
#3<VirtualHost *:80>
 #   ServerName $VH_ROUNCUBE
#    DocumentRoot /usr/share/roundcubemail
#    Redirect / https://$VH_ROUNCUBE
#</VirtualHost>
#<VirtualHost *:443>
#    ServerName $VH_ROUNCUBE
#3    ServerAlias $SRV_ALIAS
#    ServerAlias $VH_ROUNCUBE
#    ServerAdmin $MAIL_ADMIN
#    DocumentRoot /usr/share/roundcubemail
#    ErrorLog /var/log/httpd/error_log
#    SSLEngine On
#3    SSLProtocol all -SSLv2 -SSLv3
# Self Signed Certificate
#    SSLCertificateFile /etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
#    SSLCertificateKeyFile /etc/letsencrypt/live/$HOSTNAME_WEB/privkey.pem
#    SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
#    SSLHonorCipherOrder on
#    SSLCertificateFile /etc/letsencrypt/live/$HOSTNAME_WEB/cert.pem
#    SSLCertificateKeyFile /etc/letsencrypt/live/$HOSTNAME_WEB/privkey.pem
#    SSLCertificateChainFile /etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
#<Directory /usr/share/roundcubemail/>
#    Options -Indexes
#    <IfModule mod_authz_core.c>
#        Require all granted
#    </IfModule>
#</Directory>
##<Directory /usr/share/roundcubemail/installer/>
#        Order allow,deny
#        Deny from all
#</Directory>
# Those directories should not be viewed by Web clients.
#<Directory /usr/share/roundcubemail/bin/>
#    Order Allow,Deny
#    Deny from all
#</Directory>
#<Directory /usr/share/roundcubemail/plugins/enigma/home/>
#    Order Allow,Deny
#    Deny from all
#</Directory>
# Secure
#    ErrorDocument 404 /
#    Options -FollowSymLinks
#    Header always append X-Frame-Options SAMEORIGIN
#    Header set X-XSS-Protection "1; mode=block"
#</VirtualHost>
#EOT

#
#cat <<EOT >> /etc/httpd/conf.d/vh2_postfix-postfixadmin.conf
#<VirtualHost *:80>
#    ServerName $VH_POSTFIXADMIN
#    DocumentRoot /var/www/html/postfixadmin
#    Redirect / https://$VH_POSTFIXADMIN
#</VirtualHost>
#<VirtualHost *:443>
#    ServerName $VH_POSTFIXADMIN
#    ServerAdmin $MAIL_ADMIN
#    DocumentRoot /var/www/html/postfixadmin
#    ErrorLog /var/log/httpd/error_log
##   SSLEngine On
#    SSLCertificateFile /etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
#    SSLCertificateKeyFile /etc/letsencrypt/live/$HOSTNAME_WEB/privkey.pem
 #   SSLCipherSuite HIGH:!MEDIUM:!aNULL:!MD5:!RC4
#<Directory /var/www/html/postfixadmin/>
#    <IfModule mod_authz_core.c>
#        Require all granted
#    </IfModule>
# disable /setup.php
#    <Files setup.php>
#        Require all denied
#    </Files>
#</Directory>
#    Options -FollowSymLinks
#    Header set X-XSS-Protection "1; mode=block"
# Apache user/pass protection
#    <Location />
#        Order allow,deny
#        Allow from all
#        AuthType Basic
#        AuthName "Restricted Files"
#        AuthBasicProvider file
#        AuthUserFile /etc/httpd/conf/.htpasswd
#        Require user euroweb
#    </Location>
#</VirtualHost>
#EOT

echo ""
echo ""
echo ""
echo "Step 5 vhost"
sleep 10
echo ""
echo ""
echo ""
echo ""


### configure PostFix/Dovecot MAPS ##########
cat <<EOT >> /etc/postfix/mysql_virtual_alias_maps.cf
user = $POSTFIX_USER
password = $POSTFIX_PASS
hosts = localhost
dbname = $POSTFIX_SQL_DB
table = alias
select_field = goto
where_field = address
EOT

#
cat <<EOT >> /etc/postfix/mysql_virtual_domains_maps.cf
user = $POSTFIX_USER
password = $POSTFIX_PASS
hosts = localhost
dbname = $POSTFIX_SQL_DB
table = domain
select_field = domain
where_field = domain
additional_conditions = and active = '1'
EOT

#
cat <<EOT >> /etc/postfix/mysql_virtual_mailbox_maps.cf
user = $POSTFIX_USER
password = $POSTFIX_PASS
hosts = localhost
dbname = $POSTFIX_SQL_DB
table = mailbox
select_field = maildir
where_field = username
EOT

#
cat <<EOT >> /etc/postfix/mysql_virtual_mailbox_limit_maps.cf
user = $POSTFIX_USER
password = $POSTFIX_PASS
hosts = localhost
dbname = $POSTFIX_SQL_DB
query = SELECT quota FROM mailbox WHERE username='%s' AND active = '1'
EOT

#
cat <<EOT >> /etc/dovecot/dovecot-sql.conf.ext
# for PostfixAdmin
driver = mysql
connect = host=localhost dbname=$POSTFIX_SQL_DB user=$POSTFIX_USER password=$POSTFIX_PASS
default_pass_scheme = SHA512-CRYPT
# Get the password
password_query = SELECT username as user, password, '$POSTFIX_MAIL_LOCATION/%d/%n' as userdb_home, 'maildir:$POSTFIX_MAIL_LOCATION/%d/%n' as userdb_mail, $USR_ID as  userdb_uid, $USR_ID as userdb_gid FROM mailbox WHERE username = '%u' AND active = '1'
# Get the mailbox
user_query = SELECT concat('$POSTFIX_MAIL_LOCATION/%d/%n/maildir') AS home,   $USR_ID AS uid, $USR_ID AS gid,   CONCAT('*:bytes=', mailbox.quota) AS quota2_rule,   CONCAT('*:bytes=', domain.quota*1024000) AS quota_rule   FROM mailbox,domain WHERE username = '%u' AND mailbox.active = '1'   AND domain.domain = '%d'
iterate_query = SELECT username FROM mailbox
EOT

#
cat <<EOT >> /etc/dovecot/dovecot-dict-quota.conf.ext
connect = host=localhost dbname=$POSTFIX_SQL_DB user=$POSTFIX_USER password=$POSTFIX_PASS
map {
  pattern = priv/quota/storage
  table = quota2
  username_field = username
  value_field = bytes
}
map {
  pattern = priv/quota/messages
  table = quota2
  username_field = username
  value_field = messages
}
EOT

# +auth SQL for dovecot
cat <<EOT > /etc/dovecot/conf.d/10-auth.conf
!include auth-sql.conf.ext
EOT

### PostFix_MAIN.CF #####################################
cat <<EOT > /etc/postfix/main.cf
myhostname = $HOSTNAME_WEB
mydomain = $HOSTNAME_WEB
myorigin = \$myhostname
inet_interfaces = all
inet_protocols = ipv4
mydestination = localhost.\$mydomain, localhost
mynetworks = 127.0.0.0/8, $SRV_MAIL_IP/32
home_mailbox = Maildir/
smtpd_banner = \$myhostname ESMTP Unknown
disable_vrfy_command = yes
broken_sasl_auth_clients = yes
# Certificates
smtpd_tls_cert_file = /etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/$HOSTNAME_WEB/privkey.pem
# SMTP info http://www.postfix.org/TLS_README.html
# may=Even though TLS encryption is always used, mail delivery continues even if the server certificate is untrusted/wrong name
smtp_tls_security_level = may
smtp_tls_loglevel = 1
smtp_tls_protocols = !SSLv2, !SSLv3
smtp_tls_mandatory_protocols = !SSLv2, !SSLv3
#smtpd_use_tls = yes
smtpd_tls_loglevel = 1
smtpd_tls_auth_only = yes
# may=Postfix SMTP server announces STARTTLS support to remote SMTP clients, but does not require that clients use TLS encryption
smtpd_tls_security_level = may
smtpd_tls_protocols = !SSLv2, !SSLv3
smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3
smtpd_tls_mandatory_ciphers = high
smtpd_tls_mandatory_exclude_ciphers = aNULL, MD5
smtpd_sasl_type = dovecot
smtpd_sasl_path = /var/spool/postfix/private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_local_domain = \$myhostname
smtpd_sasl_security_options = noanonymous
smtpd_relay_restrictions =
    permit_mynetworks
    permit_tls_clientcerts
    permit_sasl_authenticated
    reject_unauth_destination
smtpd_client_restrictions =
    check_client_access hash:/etc/postfix/access
    reject_rbl_client zen.spamhaus.org
    reject_rbl_client bl.spamcop.net
    reject_rbl_client all.rbl.jp
    reject_non_fqdn_sender
    reject_unknown_sender_domain
    reject_invalid_hostname
smtpd_sender_restrictions =
    reject_rhsbl_sender zen.spamhaus.org
    reject_unknown_sender_domain
smtpd_recipient_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    reject_unauth_destination
    reject_non_fqdn_sender
    reject_non_fqdn_recipient
#    check_policy_service unix:private/policy-spf
# cache sessions
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
# Virtual Domain MySQL
local_transport = local
#virtual_transport = virtual
virtual_transport = dovecot
dovecot_destination_recipient_limit = 1
virtual_mailbox_base = $POSTFIX_MAIL_LOCATION
virtual_alias_maps = mysql:/etc/postfix/mysql_virtual_alias_maps.cf
virtual_alias_domains = \$virtual_alias_maps
virtual_mailbox_domains = mysql:/etc/postfix/mysql_virtual_domains_maps.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql_virtual_mailbox_maps.cf
virtual_uid_maps = static:$USR_ID
virtual_gid_maps = static:$USR_ID
virtual_minimum_uid = $USR_ID
# DKIM support for postfix
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = \$smtpd_milters
milter_default_action = accept
# Virtual delivery Postfix_VDA patched
virtual_maildir_extended = yes
virtual_mailbox_limit_maps = mysql:/etc/postfix/mysql_virtual_mailbox_limit_maps.cf
virtual_mailbox_limit_override = yes
virtual_overquota_bounce = no
virtual_trash_count = yes
# Amavisd-new
content_filter=smtp-amavis:[127.0.0.1]:10024
receive_override_options = no_address_mappings
EOT

#
cat <<EOT > /etc/postfix/master.cf
smtp      inet  n       -       n       -       -       smtpd
submission inet n       -       n       -       -       smtpd
# SASL authentication with dovecot
    -o smtpd_tls_security_level=encrypt
    -o smtpd_sasl_auth_enable=yes
    -o smtpd_sasl_type=dovecot
    -o smtpd_sasl_path=private/auth
    -o smtpd_sasl_security_options=noanonymous
    -o smtpd_sasl_local_domain=\$myhostname
    -o smtpd_client_restrictions=permit_sasl_authenticated,reject
    -o smtpd_recipient_restrictions=reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject
    -o smtpd_reject_unlisted_recipient=no
    -o milter_macro_daemon_name=ORIGINATING
smtps     inet  n       -       n       -       -       smtpd
    -o smtpd_tls_wrappermode=yes
    -o smtpd_sasl_auth_enable=yes
    -o smtpd_client_restrictions=permit_sasl_authenticated,reject
    -o receive_override_options=no_address_mappings
smtp-amavis unix  -      -       n       -       2       smtp
     -o smtp_data_done_timeout=1200
     -o smtp_send_xforward_command=yes
     -o disable_dns_lookups=yes
127.0.0.1:10025 inet n   -       n       -       -       smtpd
     -o content_filter=
     -o local_recipient_maps=
     -o relay_recipient_maps=
     -o smtpd_restriction_classes=
     -o smtpd_client_restrictions=
     -o smtpd_helo_restrictions=
     -o smtpd_sender_restrictions=
     -o smtpd_recipient_restrictions=permit_mynetworks,reject
     -o smtpd_data_restrictions=reject_unauth_pipelining
     -o mynetworks=127.0.0.0/8
     -o mynetworks_style=host
     -o strict_rfc821_envelopes=yes
     -o smtpd_error_sleep_time=0
     -o smtpd_soft_error_limit=1001
     -o smtpd_hard_error_limit=1000
     -o receive_override_options=no_address_mappings
     -o receive_override_options=no_header_body_checks,no_unknown_recipient_checks
     -o smtpd_milters=
dovecot  unix    -       n       n       -       -       pipe
     flags=DRhu user=$POSTFIX_USER:$POSTFIX_USER argv=/usr/libexec/dovecot/deliver -f \${sender} -d \${user}@\${nexthop} -a \${original_recipient}1
# Prevent sender address forgery with Sender Policy Framework(SPF); postfix checks SPF record on all incoming email#
policy-spf unix -       n       n       -       0       spawn
     user=nobody argv=/usr/bin/python /usr/libexec/postfix/policyd-spf /etc/python-policyd-spf/policyd-spf.conf
pickup    fifo  n       -       -       60      1       pickup
cleanup   unix  n       -       n       -       0       cleanup
qmgr      fifo  n       -       n       300     1       qmgr
#qmgr     fifo  n       -       -       300     1       oqmgr
tlsmgr    unix  -       -       -       1000?   1       tlsmgr
rewrite   unix  -       -       n       -       -       trivial-rewrite
bounce    unix  -       -       -       -       0       bounce
defer     unix  -       -       -       -       0       bounce
trace     unix  -       -       -       -       0       bounce
verify    unix  -       -       -       -       1       verify
flush     unix  n       -       -       1000?   0       flush
proxymap  unix  -       -       n       -       -       proxymap
smtp      unix  -       -       n       -       -       smtp
        -o smtp_bind_address=$SRV_MAIL_IP
proxywrite unix -       -       n       -       1       proxymap
anvil     unix  -       -       n       -       1       anvil
EOT

postmap /etc/postfix/access

echo ""
echo ""
echo ""
echo "Step 6 postfix config"
sleep 10
echo ""
echo ""
echo ""
echo ""


## conf_Dovecot ###
cat <<EOT >> /etc/dovecot/local.conf
## dovecot.conf
protocols = imap pop3 sieve
listen = *
## 10-auth.conf
disable_plaintext_auth = yes
auth_mechanisms = plain login cram-md5
#!include auth-system.conf.ext
#!include dovecot-sql.conf.ext
passdb {
  driver = pam
}
userdb {
  driver = passwd
}
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
## 10-mail.conf
mail_location = maildir:$POSTFIX_MAIL_LOCATION/%d/%n
first_valid_uid = $USR_ID
first_valid_gid = $USR_ID
namespace inbox {
  separator = .
  prefix =
  location = maildir:$POSTFIX_MAIL_LOCATION/%d/%n/maildir
  inbox = yes
  mailbox Trash {
    auto = subscribe
    special_use = \Trash
  }
  mailbox Drafts {
    auto = subscribe
    special_use = \Drafts
  }
  mailbox Sent {
    auto = subscribe
    special_use = \Sent
  }
  mailbox Junk {
    auto = subscribe
    special_use = \Junk
  }
  mailbox virtual/All {
    auto = no
    special_use = \All
  }
}
## 10-master.conf
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
  # Sive Setting
    unix_listener auth-client {
        group = postfix
        mode = 0660
        user = postfix
    }
    unix_listener auth-master {
        group = $POSTFIX_USER
        mode = 0660
        user = $POSTFIX_USER
    }
    user = root
  # Sive Setting
}
service dict {
  unix_listener dict {
    mode = 0660
    user = $POSTFIX_USER
    group = $POSTFIX_USER
  }
}
## 10-ssl.conf
ssl_cert = </etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
ssl_key = </etc/letsencrypt/live/$HOSTNAME_WEB/privkey.pem
ssl_ca = </etc/letsencrypt/live/$HOSTNAME_WEB/fullchain.pem
ssl_verify_client_cert = yes
ssl_protocols = !SSLv2 !SSLv3
ssl = required
mail_plugins = \$mail_plugins quota
##15-lda.conf
protocol lda {
  mail_plugins = \$mail_plugins quota sieve
  postmaster_address = postmaster@$HOSTNAME_WEB
  hostname = $HOSTNAME_WEB
  auth_socket_path = /var/run/dovecot/auth-master
  log_path = $POSTFIX_MAIL_LOCATION/dovecot-lda-errors.log
  info_log_path = $POSTFIX_MAIL_LOCATION/dovecot-lda.log
}
## 20-imap.conf
protocol imap {
  imap_client_workarounds = delay-newmail tb-extra-mailbox-sep
  mail_plugins = \$mail_plugins quota virtual imap_quota
}
## 20-lmtp.conf
protocol lmtp {
  mail_plugins = \$mail_plugins quota sieve
  log_path = $POSTFIX_MAIL_LOCATION/dovecot-lmtp-errors.log
  info_log_path = $POSTFIX_MAIL_LOCATION/dovecot-lmtp.log
}
## 20-managesieve.conf
service managesieve-login {
  inet_listener sieve {
    port = 4190
  }
}
service managesieve {
  process_limit = 1024
  process_min_avail = 2
}
protocol sieve {
  managesieve_max_line_length = 65536
  managesieve_implementation_string = dovecot
  log_path = $POSTFIX_MAIL_LOCATION/dovecot-sieve-errors.log
  info_log_path = $POSTFIX_MAIL_LOCATION/dovecot-sieve.log
}
## 20-pop3.conf
protocol pop3 {
  mail_plugins = quota
  pop3_client_workarounds = outlook-no-nuls oe-ns-eoh
}
## 90-plugin.conf
dict {
    quota = mysql:/etc/dovecot/dovecot-dict-quota.conf.ext
}
plugin {
# quota mysql support 
    quota2 = dict:User quota::proxy::quota
    quota = dict:Domain quota:%d:proxy::quota
#quota warning
    quota_warning = storage=95%% quota-warning 95 %u
    quota_warning2 = storage=80%% quota-warning 80 %u
# quota status
    quota_status_success = DUNNO
    quota_status_nouser = DUNNO
    quota_status_overquota = "552 Mailbox is full"
    quota_exceeded_message = Quota exceeded (mailbox is full). 
}
service quota-warning {
  executable = script /usr/local/bin/quota-warning.sh
  # use some unprivileged user for executing the quota warnings
  user = $POSTFIX_USER
  unix_listener quota-warning {
     group = $POSTFIX_USER 
     mode = 0660
     user = $POSTFIX_USER
  }
}
service quota-status {
    executable = quota-status -p postfix
    inet_listener {
        port = 25357
    }
    client_limit = 1
}
## 90-sieve.conf
plugin {
  sieve_default_name = roundcube  
  sieve = $POSTFIX_MAIL_LOCATION/%d/%n/.dovecot.sieve
  sieve = $POSTFIX_MAIL_LOCATION/%d/%n/sieve/manage.sieve
  sieve_dir = $POSTFIX_MAIL_LOCATION/%d/%n/sieve
  sieve_global_dir = /etc/dovecot/sieve/global/
  sieve_global_path = /etc/dovecot/sieve/default.sieve
}
# Dovecot tunning
maildir_very_dirty_syncs = yes
maildir_copy_with_hardlinks = yes
maildir_stat_dirs = no
pop3_no_flag_updates=yes
mailbox_list_index=yes
# Debug
#mail_debug=yes
#auth_verbose=yes
#auth_debug=yes
#verbose_ssl=yes
#auth_verbose_passwords=plain
EOT

mkdir -p /etc/dovecot/sieve/global
cat <<EOT >> /etc/dovecot/sieve/default.sieve
# sieve SPAM filter
require ["fileinto"];
# rule:[SPAM1]
if header :contains "X-Spam-Flag" "YES" {
    fileinto "Junk";
}
if header :contains "X-Spam-Level" "***" {
    fileinto "Junk";
}
# rule:[SPAM2]
elsif header :matches "Subject" ["*100% free*","*lottery*"] {
    fileinto "Junk";
}
EOT
sievec /etc/dovecot/sieve/default.sieve

# script quota-warning ##
cat <<EOT >> /usr/local/bin/quota-warning.sh
#!/bin/sh
PERCENT=\$1
USER=\$2
cat << EOF | /usr/libexec/dovecot/dovecot-lda -d \$USER -o "plugin/quota = dict:User quota::noenforcing:proxy::quota"
From: postmaster@$HOSTNAME_WEB
Subject: quota warning
Your mailbox is now \$PERCENT% full.
EOF
EOT

# quota-warning script
chown $POSTFIX_USER:$POSTFIX_USER /usr/local/bin/quota-warning.sh
chmod +x /usr/local/bin/quota-warning.sh

# conf_Amavisd-New ###
sed -i "s|^\(\$mydomain\ =\).*$|\1 \'localhost\';|" /etc/amavisd/amavisd.conf
# configure spam filters
sed -i "s|^\(\$sa_tag2_level_deflt\ =\).*$|\1\ 4.0\;|" /etc/amavisd/amavisd.conf
sed -i "s|^\(\$sa_kill_level_deflt\ =\).*$|\1\ \$sa_tag2_level_deflt\;|" /etc/amavisd/amavisd.conf

# amavis - razor config
echo "loadplugin Mail::SpamAssassin::Plugin::Razor2" >> /etc/mail/spamassassin/v340.pre
mkdir /etc/mail/spamassassin/.razor
razor-admin -home=/etc/mail/spamassassin/.razor -register
razor-admin -home=/etc/mail/spamassassin/.razor -create
razor-admin -home=/etc/mail/spamassassin/.razor -discover
echo "razorhome = /etc/mail/spamassassin/.razor" >> /etc/mail/spamassassin/.razor/razor-agent.conf
chown -R amavis:amavis /etc/mail/spamassassin/.razor

cat <<EOT >> /etc/mail/spamassassin/local.cf
# razor
use_razor2 1
razor_config /etc/mail/spamassassin/.razor/razor-agent.conf
score RAZOR2_CHECK 3.000
EOT

#
cat <<EOT >> /etc/amavisd/amavisd.conf
 @lookup_sql_dsn = (
     ['DBI:mysql:database=$POSTFIX_SQL_DB;host=127.0.0.1;port=3306', '$POSTFIX_USER', '$POSTFIX_PASS'],
 );
 \$sql_select_white_black_list = undef;
 \$sql_select_policy = 'SELECT "Y" as local, 1 as id FROM domain WHERE
     CONCAT("@",domain) IN (%k)';
\$recipient_delimiter = undef;
EOT

## _config_CLAM@amavis
sed -i -e 's/^Example/#Example/' /etc/freshclam.conf
echo > /etc/sysconfig/freshclam

echo ""
echo ""
echo ""
echo "Step 7 davcot config"
sleep 10
echo ""
echo ""
echo ""
echo ""


#  start @mail services #
#systemctl start postfix dovecot httpd mariadb amavisd clamd@amavisd spamassassin opendkim
systemctl start postfix dovecot amavisd clamd@amavisd spamassassin opendkim
#systemctl start postfix dovecot httpd mariadb amavisd clamd@amavisd spamassassin opendkim
# Configure MySQL_secure_install ###
#mysql_secure_installation <<EOF
#y
#$SQL_ROOT_PASS
#$SQL_ROOT_PASS
#y
#y
#y
#y
#EOF
#
echo ""
echo ""
echo ""
echo "Step 8 restart"
sleep 10
echo ""
echo ""
echo ""
echo ""

# postfix-db / rouncube-db
mysql -uroot -p$SQL_ROOT_PASS -e "CREATE DATABASE $POSTFIX_SQL_DB CHARACTER SET utf8 COLLATE utf8_general_ci;" 
mysql -uroot -p$SQL_ROOT_PASS -e "CREATE DATABASE $ROUNDCUBE_DB CHARACTER SET utf8 COLLATE utf8_general_ci;"

mysql -uroot -p$SQL_ROOT_PASS -e "CREATE USER $POSTFIX_USER@localhost IDENTIFIED BY '$POSTFIX_PASS';"
mysql -uroot -p$SQL_ROOT_PASS -e "CREATE USER $ROUNDCUBE_USER@localhost IDENTIFIED BY '$ROUNDCUBE_PASS';"

mysql -uroot -p$SQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $POSTFIX_SQL_DB.* TO '$POSTFIX_USER'@'localhost';"
mysql -uroot -p$SQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $ROUNDCUBE_DB.* TO '$ROUNDCUBE_USER'@'localhost';"
mysql -uroot -p$SQL_ROOT_PASS -e "FLUSH PRIVILEGES;"

#initialize RoundCube-DB
mysql -u root -p$SQL_ROOT_PASS $ROUNDCUBE_DB < /usr/share/roundcubemail/SQL/mysql.initial.sql

# cron existing ##
# spamassassin cron update /etc/cron.d/sa-update
# freshclam cron update    /etc/cron.d/clamav-update

echo ''
echo ''

echo ""
echo ""
echo ""
echo "Step 9 mysql done!"
sleep 10
echo ""
echo ""
echo ""
echo ""

chown -R lighttpd:lighttpd /home/html
#######################################


echo "
installed/configured:
+ Dovecot(managesieve)
+ Amavisd(SpamaassAssin{+razor}+Clamd@amavisd)
+ MariaDB(MySQL)
+ OpenDKIM
+ Apache2.4(Apache-mod_security#+crs)
+ policy-SPF
+ PostfixAdmin
+ Rouncube
## to do ##
- configured pass for postfixadmin now create admin-user at https://$VH_POSTFIXADMIN/setup.php   
- configure final_virus/spam_destiny /etc/amavisd/amavisd.conf
- secure postfixadmin (apache)
- setup iptables
- dkim add DNS text
- "


echo '############# POSTFIX ADMIN CONFIGURATION ##########################'
echo ''
echo "Get Pass Hash at https://$VH_POSTFIXADMIN/setup.php"
echo 'and run the command wget https://raw.github.com/munishgaurav5/st/master/pf.sh  && chmod 777 pf.sh && ./pf.sh '
echo ''
echo ' To setup DKIM run the command wget https://raw.github.com/munishgaurav5/st/master/dk.sh && chmod 777 dk.sh && ./dk.sh '
echo ''
echo ''
