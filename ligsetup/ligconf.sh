#!/bin/bash

chown -R admin:admin /var/opt/remi/php70

#### PHP WWW Admin Config

sed -i "s/^.*user = apache.*/user = admin/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/^.*group = apache.*/group = admin/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s,^.*listen = 127.0.0.1:9000.*,listen = /run/php-admin.sock," /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/^.*listen.mode = 06.*/listen.mode = 0666/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s/^.*listen.acl_users = .*/listen.acl_users = admin/" /etc/opt/remi/php70/php-fpm.d/www.conf

sed -i "s/^.*Start a new pool named 'www'.*/[global]/" /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s,^.*expose_php =.*,pid = /run/php-admin.pid," /etc/opt/remi/php70/php-fpm.d/www.conf
sed -i "s,^.*pm.status_path =.*,pm.status_path = /status/php.php ," /etc/opt/remi/php70/php-fpm.d/www.conf

#####

#### Lighttpd Config File
echo '
server.stream-response-body = 1
server.tag = "LiteSpeed Web Server"
include_shell "cat /etc/lighttpd/enabled/*.conf"
' >> /etc/lighttpd/lighttpd.conf

sed -i 's/^.*server.use-ipv6 =.*/server.use-ipv6 = "disable"/' /etc/lighttpd/lighttpd.conf
sed -i 's,^.*server.document-root =.*,server.document-root = "/home/admin/web/ip",' /etc/lighttpd/lighttpd.conf
sed -i 's/^.*server.network-backend =.*/server.network-backend = "writev"/' /etc/lighttpd/lighttpd.conf
sed -i 's/^.*server.max-fds =.*/server.max-fds = 6048/' /etc/lighttpd/lighttpd.conf
sed -i 's/^.*server.max-connections =.*/server.max-connections = 3000/' /etc/lighttpd/lighttpd.conf
#sed -i 's/^.*__.*/__/' /etc/lighttpd/lighttpd.conf
#sed -i 's/^.*__.*/__/' /etc/lighttpd/lighttpd.conf
#sed -i 's/^.*__.*/__/' /etc/lighttpd/lighttpd.conf

####

#### Modules Config
/etc/lighttpd/modules.conf
sed -i 's/^.*"mod_alias",.*/  "mod_alias",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_auth",.*/  "mod_auth",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_authn_file",.*/  "mod_authn_file",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_evasive",.*/  "mod_evasive",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_redirect",.*/  "mod_redirect",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_rewrite",.*/  "mod_rewrite",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_setenv",.*/  "mod_setenv",/' /etc/lighttpd/modules.conf
sed -i 's/^.*"mod_usertrack",.*/  "mod_usertrack",/' /etc/lighttpd/modules.conf

sed -i 's/^.*include "conf.d/expire.conf".*/  include "conf.d/expire.conf"/' /etc/lighttpd/modules.conf
sed -i 's/^.*include "conf.d/fastcgi.conf".*/  include "conf.d/fastcgi.conf"/' /etc/lighttpd/modules.conf
sed -i 's/^.*include "conf.d/cgi.conf".*/  include "conf.d/cgi.conf"/' /etc/lighttpd/modules.conf

####

#### Fastcgi Config

echo '
server.modules += ( "mod_fastcgi" )
# FastCGI unix socket setting for ADMIN
fastcgi.server += ( ".php" =>
        ((
#                "host" => "127.0.0.1",
#                "port" => "9000",
                "socket" => "/run/php-admin.sock",
                "broken-scriptfilename" => "enable"
        ))
)
' > /etc/lighttpd/conf.d/fastcgi.conf

#####


## enabled folder
## sock php
## /home/admin/web/ip
## lighttpd user lighttpd
